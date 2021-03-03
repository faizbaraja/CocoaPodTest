
import Foundation
import WebKit

protocol AnnounceKitServiceProtocol {
    func updateUnreadCount(unreadCount:Int)
}

class AnnounceKitService {
    let webView: WKWebView
    private let messenger: WhatsNewServiceMessenger
    
    private let widgetId: String
    private let selector: String = ".announcekit-widget"
    //private var additionalParameter:[String] = []
    private var additionalParameter:[String:String] = [:]
    
    var delegate:AnnounceKitServiceProtocol?
    
    
    /// Instantiate the AnnounceKitService
    /// - Parameter widgetId: the widget id that that will be displayed
    init (widgetId: String) {
        let messenger = WhatsNewServiceMessenger()
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(messenger, name: messenger.updateUnreadCount)
        configuration.userContentController.add(messenger, name: messenger.logHandler)
        
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        
        self.messenger = messenger
        self.widgetId = widgetId
        
        
        self.messenger.serviceDelegate = self
//        self.configure()
    }
    
    private func configure() {
        
        let script =    """
                        function start() {
                        \(self.pushFunctionString())
                        }
                        """
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        webView.configuration.userContentController.addUserScript(userScript)
    }
    
    public func loadPage() {
        configure()
        
        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource: "whatsNewService", withExtension: "html") {
            self.webView.load(URLRequest(url: url))
        }
    }
    
    private func pushFunctionString() -> String {
        return """
                announcekit.push({
                    // Standard config
                    widget: "https://announcekit.app/widgets/v2/\(self.widgetId)",
                    selector: "\(self.selector)",
                    data: {
                        platform: "ios"
                    },
                    \(additionalParameter.values.joined(separator: ","))
                });
            """
    }
    
    func setLang(lang:String) {
        let parameter = """
                        lang: "\(lang)"
                        """
        additionalParameter["lang"] = parameter
    }
    
    func setUser(id:String, email:String?, name:String?) {
        var userDictionary:[String:String] = [:]
        userDictionary["id"] = """
                                \(id)
                                """
        if let email = email {
            userDictionary["email"] = """
                                        \(email)
                                        """
        }

        if let name = name {
            userDictionary["name"] = """
                                    \(name)
                                    """
        }

        let userData = (userDictionary.compactMap({ (key, value) -> String in
            return """
                   \(key):"\(value)"
                   """
        }) as Array).joined(separator: ",")
        
        let parameter = """
                        user: {\(userData)}
                        """
        additionalParameter["user"] = parameter
    }
    
    func reloadWidget() {
        let script = pushFunctionString()
        webView.evaluateJavaScript(script) { (result, error) in
            if error != nil {
                print(result ?? Error.self)
            }
        }
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
    
    weak var serviceDelegate: AnnounceKitService?
    
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
            serviceDelegate?.updateUnreadCount(unreadCount: unread)
        case logHandler:
            print("\(message.body)")
        case errorHandler:
            print("\(message.body)")
        default:
            print("error – unknow \(message.name)")
        }
    }
}
