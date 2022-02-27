//
//  TabBarControllerDelegator.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit

class TabBarControllerDelegator: NSObject, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabBarController = tabBarController as? TabBarController else { return }
        
        let index = tabBarController.selectedIndex
        for observer in tabBarController.observers {
            observer.tabBarController(tabBarController, didSelectAt: index)
        }
    }
    
}
