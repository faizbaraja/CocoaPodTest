//
//  WhatsNewViewController.swift
//  SKVideo
//
//  Created by Francescu Santoni on 30/11/2020.
//  Copyright © 2020 Archery Inc. All rights reserved.
//

import UIKit

public protocol WhatsNewViewControllerProtocol {
    func updateUnreadCount(unreadCount:Int)
}

public class WhatsNewViewController: UIViewController {

    var service: WhatsNewService?
    
    var delegate:WhatsNewViewControllerProtocol?
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public func postPageViewController(userId:String?, widgetId:String) -> WhatsNewViewController {
        self.service = WhatsNewService(userId: userId, widgetId: widgetId, unreadCountWidgetId: widgetId)
        self.service?.delegate = self
        
        guard let webView = service?.webView else { return self }
        webView.frame = self.view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        return self
    }
    
    public func getUnreadCount(userId:String?, widgetId:String, delegate:WhatsNewViewControllerProtocol?){
        self.service = WhatsNewService(userId: userId, widgetId: widgetId, unreadCountWidgetId: widgetId)
        self.delegate = delegate
        self.service?.delegate = self
        guard let _ = service?.webView else { return }
    }
    
    deinit {
        service = nil
    }
}

extension WhatsNewViewController: WhatsNewServiceProtocol {
    func updateUnreadCount(unreadCount: Int) {
        if let delegate = delegate {
            delegate.updateUnreadCount(unreadCount: unreadCount)
        }
    }
}
