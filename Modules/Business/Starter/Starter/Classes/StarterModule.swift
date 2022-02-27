//
//  StarterModule.swift
//  Starter
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit
import PGFoundation
import Provider
import UIComponents

public class StarterModule: PGModule {
    
    public static var shared: PGModule = StarterModule()
    
    private var tabBarController = TabBarController()
    
    public func runModule() {
        PGProviderManager.shared.registerProvider({ StarterProvider.self }, self)
    }
    
    public func applicationDidFinishLaunching() {
        configTabBarController()
    }
    
    deinit {
        PGProviderManager.shared.deregisterProvider({ StarterProvider.self })
    }
    
}

// MARK: - StarterProvider
extension StarterModule: StarterProvider {
    
    public func getTabBarController() -> UITabBarController {
        tabBarController
    }
    
}

// MARK: - Tabs
extension StarterModule {
   
    private func configTabBarController() {
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = tabBarController.tabBar.standardAppearance
        }
        
        guard let toDoService = PGProviderManager.shared.provider(forProtocol: { ToDoProvider.self }) else { return }
        
        var controllers = [UIViewController]()
        
        let homeVC = toDoService.getToDoViewController()
        homeVC.view.backgroundColor = .systemOrange
        homeVC.tabBarItem = UITabBarItem(title: "home", image: nil, selectedImage: nil)
        controllers.append(homeVC)
        
        let testVC = UIViewController()
        testVC.view.backgroundColor = .systemPink
        testVC.tabBarItem = UITabBarItem(title: "test", image: nil, selectedImage: nil)
        controllers.append(testVC)
        
        tabBarController.viewControllers = controllers
    }

}
