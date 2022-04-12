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
        guard let bbsService = PGProviderManager.shared.provider(forProtocol: { BBSProvider.self }) else { return }
        
        var controllers = [UIViewController]()
        
        if let homeVC = toDoService.getToDoViewController() {
            let home = UINavigationController(rootViewController: homeVC)
            home.tabBarItem = UITabBarItem(title: "home", image: nil, selectedImage: nil)
            controllers.append(home)
        }
        
        if let bbsVC = bbsService.getBBSViewController() {
            let bbs = UINavigationController(rootViewController: bbsVC)
            bbs.tabBarItem = UITabBarItem(title: "xxx社区", image: nil, selectedImage: nil)
            controllers.append(bbs)
        }
        
        let testVC = TestViewController()
        testVC.tabBarItem = UITabBarItem(title: "test", image: nil, selectedImage: nil)
        controllers.append(testVC)
        
        tabBarController.viewControllers = controllers
    }

}

fileprivate class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let button = UIButton(type: .system)
        button.setTitle("登录", for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc
    func buttonTapped() {
        let accountService = PGProviderManager.shared.provider { AccountProvider.self }
        accountService?.presentLoginViewController(from: self, animated: true)
    }
    
}
