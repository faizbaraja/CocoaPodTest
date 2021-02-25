import UIKit

public protocol AnnounceKitProtocol {
    func updateUnreadCount(unreadCount:Int)
}

public class AnnounceKit {

    var service: AnnounceKitService?
    
    var delegate:AnnounceKitProtocol?
    
    let widgetId:String
    
    public init(widgetId:String) {
        self.widgetId = widgetId
        self.service = AnnounceKitService(widgetId: self.widgetId)
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
    
    public func getUnreadCount(delegate:AnnounceKitProtocol?){
        self.delegate = delegate
        self.service?.delegate = self
        self.service?.loadPage()
    }
    
    public func setLanguage(lang:String) {
        self.service?.setLang(lang: lang)//language = lang
        self.service?.runScript()
    }
    
    deinit {
        service = nil
    }
}

extension AnnounceKit: AnnounceKitServiceProtocol {
    func updateUnreadCount(unreadCount: Int) {
        if let delegate = delegate {
            delegate.updateUnreadCount(unreadCount: unreadCount)
        }
    }
}
