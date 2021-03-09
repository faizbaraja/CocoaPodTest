
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
    private var widgetParameters:WidgetParameter = WidgetParameter()
    private var additionalData:[String:Any] = ["platform":"ios"]
    
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
    }
    
    private func setBasicParam() {
//        let widgetData = WidgetParameter.Data(platform: "ios")
        
        widgetParameters.widget = "https://announcekit.app/widgets/v2/\(self.widgetId)"
        widgetParameters.selector = selector
//        widgetParameters.data = widgetData
    }
    
    private func configure() {
        setBasicParam()
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
        if var widgetParamDictionary = widgetParameters.dictionary {
            widgetParamDictionary["data"] = additionalData
            if let jsonData = try? JSONSerialization.data(withJSONObject: widgetParamDictionary, options: [.prettyPrinted]) {
                let jsonString = String(data: jsonData, encoding: .utf8)!
                return """
                        announcekit.push(\(jsonString));
                    """
            }
        }

        let jsonData = try! JSONEncoder().encode(widgetParameters)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return """
                announcekit.push(\(jsonString));
            """
    }
    
    func setLang(lang:String) {
        widgetParameters.lang = lang
        
        reloadWidget()
    }
    
    func setUser(id:String, email:String?, name:String?) {
        let userParam = WidgetParameter.User(id: id, name: name, email: email)
        widgetParameters.user = userParam
        
        reloadWidget()
    }
    
    public func setAdditionalData(data:[String: Any]) {
        for (_, dictData) in data.enumerated() {
            additionalData[dictData.key] = dictData.value
        }
        reloadWidget()
    }
    
    private func reloadWidget() {
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

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
