//
//  TabBarController.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/2/26.
//

import UIKit

public class TabBarController: UITabBarController {
    
    public var observers = [TabBarControllerObservable]()
    
    private var delegator = TabBarControllerDelegator()

    public override func viewDidLoad() {
        super.viewDidLoad()

        delegate = delegator
    }
    
    public func selectController(at index: Int) {
        if index >= viewControllers?.count ?? 0 {
            return
        }
        selectedIndex = index
    }
    
    public func addTabBarControllerObserver(_ observer: TabBarControllerObservable) {
        observers.append(observer)
    }

}
