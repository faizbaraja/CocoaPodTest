//
//  ServiceManager.swift
//  BarajaFramework
//
//  Created by faiz baraja on 2/16/21.
//

import UIKit

public class ServiceManager {
    public init(){}
    
    public func printLog() {
        print("this is baraja framework")
    }
    
    public func getTestVC() -> TestViewController {
        return TestViewController(nibName: "TestViewController", bundle: Bundle(for: type(of: self)))
    }
}
