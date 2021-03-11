import UIKit

public protocol AnnounceKitProtocol:class {
    func widgetOpen(widget:[String:Any])
    func widgetClose(widget:[String:Any])
    func widgetState(uiState:[String:Any]?)
}

public class AnnounceKit {

    var service: AnnounceKitService?
    
    let widgetId:String
    
    private var unreadCount:Int = 0
    public weak var delegate: AnnounceKitProtocol?
    
    public init(widgetId:String, delegate:AnnounceKitProtocol? = nil) {
        self.widgetId = widgetId
        self.service = AnnounceKitService(widgetId: self.widgetId)
        self.service?.delegate = self
        self.service?.loadPage()
        self.delegate = delegate
    }
    
    public func createWidget() -> UIViewController {
        let containerViewController = UIViewController()

        guard let webView = service?.webView else { return containerViewController }
        webView.frame = containerViewController.view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerViewController.view.addSubview(webView)
        
        self.service?.loadPage()
        return containerViewController
    }
    
    public func getUnreadCount() -> Int {
        return unreadCount
    }
    
    public func setLanguage(lang: String) {
        self.service?.setLang(lang: lang)
    }
    
    public func setUser(id: String, email: String?, name: String?) {
        self.service?.setUser(id:id, email:email, name:name)
    }
    
    public func setAdditionalData(data:[String: Any]) {
        self.service?.setAdditionalData(data: data)
    }
    
    deinit {
        service = nil
    }
}

extension AnnounceKit: AnnounceKitServiceProtocol {
    func widgetState(uiState: [String : Any]?) {
        delegate?.widgetState(uiState: uiState)
    }
    
    func updateUnreadCount(unreadCount: Int) {
        self.unreadCount = unreadCount
    }
    
    func widgetOpen(widget:[String:Any]) {
        delegate?.widgetOpen(widget: widget)
    }
    
    func widgetClose(widget:[String:Any]) {
        delegate?.widgetClose(widget: widget)
    }
}
