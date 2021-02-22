
import Foundation
import WebKit

protocol WhatsNewServiceProtocol {
    func updateUnreadCount(unreadCount:Int)
}

class WhatsNewService {    
    let webView: WKWebView
    private let messenger: WhatsNewServiceMessenger
    
    private let widgetId: String
    private let userId: String?
    private let unreadCountWidgetId: String
    
    var delegate:WhatsNewServiceProtocol?
    
    /// Instanciate, Configure the service, and start loading the What's new
    /// - Parameters:
    ///   - userId: the user id passed to AnnounceKit, used to keep the unread count
    ///   - widgetId: an "embed" widget that will be displayed
    ///   - unreadCountWidgetId: a "direct link" widget to get unread count before displaying
    init (userId: String?, widgetId: String, unreadCountWidgetId: String) {
        let messenger = WhatsNewServiceMessenger()
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(messenger, name: messenger.updateUnreadCount)
        configuration.userContentController.add(messenger, name: messenger.logHandler)
        
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        
        self.messenger = messenger
        self.widgetId = widgetId
        self.userId = "DEBUG_00" + (userId ?? "")
        self.unreadCountWidgetId = unreadCountWidgetId
        
        self.messenger.serviceDelegate = self
        self.configure()
    }
    
    private func configure() {
        
        let script =    """
                        function start() {
                        \(Self.pushFunctionString(userId: (userId ?? ""), widgetId: widgetId, selector: ".announcekit-widget"))
                        }
                        """
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)
        
        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource: "whatsNewService", withExtension: "html") {
            self.webView.load(URLRequest(url: url))
        }
    }
    
    static private func pushFunctionString(userId: String, widgetId: String, selector: String) -> String {
        return """
                            announcekit.push({
                                // Standard config
                                widget: "https://announcekit.app/widgets/v2/\(widgetId)",
                                selector: "\(selector)",
                                user: {
                                    id: "\(userId)"
                                },
                                data: {
                                    platform: "ios",
                                    version: "14.0"
                                }
                            });
            """
    }
    
    fileprivate func updateUnreadCount(unreadCount:Int?) {
        if let unreadCount = unreadCount {
            delegate?.updateUnreadCount(unreadCount: unreadCount)
        }
    }
}

fileprivate class WhatsNewServiceMessenger: NSObject, WKScriptMessageHandler {
    let updateUnreadCount = "updateUnreadCount"
    let logHandler = "logHandler"
    let errorHandler = "errorHandler"
    
    weak var serviceDelegate: WhatsNewService?
    
    override init() {
        super.init()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case updateUnreadCount:
            guard let dict = message.body as? [String: Any],
                  let unread = dict["unread"] as? Int? else {
                return
            }
            serviceDelegate?.updateUnreadCount(unreadCount: unread)//unreadCount.update(unread)
        case logHandler:
            print("\(message.body)")
        case errorHandler:
            print("\(message.body)")
        default:
            print("error – unknow \(message.name)")
        }
    }
}
