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
        
        guard let toDoService = PGProviderManager.shared.provider(forProtocol: { ToDoProvider.self }) else {
            print("toDoService 获取失败")
            return
        }
        
        guard let bbsService = PGProviderManager.shared.provider(forProtocol: { BBSProvider.self }) else {
            print("bbsService 获取失败")
            return
        }
        
        guard let mineService = PGProviderManager.shared.provider(forProtocol: { MineProvider.self }) else {
            print("mineService 获取失败")
            return
        }
        
        var controllers = [UIViewController]()
        
        if let homeVC = toDoService.getToDoViewController() {
            let home = UINavigationController(rootViewController: homeVC)
            home.tabBarItem = UITabBarItem(title: "任务", image: UIImage(named: "todoListTab_off"), selectedImage: UIImage(named: "todoListTab_on"))
            controllers.append(home)
        }
        
        if let bbsVC = bbsService.getBBSViewController() {
            let bbs = UINavigationController(rootViewController: bbsVC)
            bbs.tabBarItem = UITabBarItem(title: "社区", image: UIImage(named: "bbsTab_off"), selectedImage: UIImage(named: "bbsTab_on"))
            controllers.append(bbs)
        }
        
        if let mineVC = mineService.getMineViewController() {
            let mine = UINavigationController(rootViewController: mineVC)
            mine.tabBarItem = UITabBarItem(title: "我的", image: UIImage(named: "user_off"), selectedImage: UIImage(named: "user_on"))
            controllers.append(mine)
        }
        
        tabBarController.viewControllers = controllers
    }

}
