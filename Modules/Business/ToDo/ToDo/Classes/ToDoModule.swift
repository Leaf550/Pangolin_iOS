//
//  AccountModule.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/27.
//

import PGFoundation
import Provider

class ToDoModule: PGModule {
    
    public static var shared: PGModule = ToDoModule()
    
    func runModule() {
        PGProviderManager.shared.registerProvider({ ToDoProvider.self }, self)
    }
    
    deinit {
        PGProviderManager.shared.deregisterProvider({ ToDoProvider.self })
    }

}

extension ToDoModule: ToDoProvider {
    
    func getToDoViewController() -> UIViewController? {
        HomeViewController()
    }
    
}
