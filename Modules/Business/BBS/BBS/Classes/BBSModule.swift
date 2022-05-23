//
//  BBSModule.swift
//  BBS
//
//  Created by 方昱恒 on 2022/2/27.
//

import PGFoundation
import Provider
import Router

class BBSModule: PGModule {
    
    public static var shared: PGModule = BBSModule()
    
    func runModule() {
        PGProviderManager.shared.registerProvider({ BBSProvider.self }, self)
        
        registerRouter()
    }
    
    deinit {
         PGProviderManager.shared.deregisterProvider({ BBSProvider.self })
    }
    
    private func registerRouter() {
        let entrance = RouterEntrance { _, userInfo in
            guard let task = userInfo as? TaskModel else { return nil }
            let newPost = NewPostViewController(task: task)
            let navigarion = UINavigationController(rootViewController: newPost)
            
            return navigarion
        }
        entrance.animationStyle = .present
        
        Router.register(url: "pangolin://newPost/", with: entrance)
    }

}

extension BBSModule: BBSProvider {
    
    func getBBSViewController() -> UIViewController? {
        return BBSViewController()
    }
    
}

