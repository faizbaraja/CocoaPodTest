import UIKit

public class AnnounceKit {

    var service: AnnounceKitService?
    
    let widgetId:String
    
    private var unreadCount:Int = 0
    
    public init(widgetId:String) {
        self.widgetId = widgetId
        self.service = AnnounceKitService(widgetId: self.widgetId)
        self.service?.loadPage()
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
    func updateUnreadCount(unreadCount: Int) {
        self.unreadCount = unreadCount
    }
}
