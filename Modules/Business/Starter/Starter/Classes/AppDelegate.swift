//
//  AppDelegate.swift
//  Starter
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit
import Foundation
import PGFoundation
import Provider

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let moduleManager = PGModuleManager.shared

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        moduleManager.loadModules()
        moduleManager.runModules()
        moduleManager.notifyApplicationWillFinishLaunching()
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        moduleManager.notifyApplicationDidFinishLaunching()
        
        let startProvider = PGProviderManager.shared.provider(forProtocol: { StarterProvider.self })
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = startProvider?.getTabBarController()
        window?.makeKeyAndVisible()
        
        moduleManager.notifyApplicationDidSetUpViews()
        
        return true
    }


}

