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
        registUserSignObserver()
    }
    
    deinit {
        PGProviderManager.shared.deregisterProvider({ ToDoProvider.self })
    }
    
    private func registUserSignObserver() {
        let accountService = PGProviderManager.shared.provider { AccountProvider.self }
        accountService?.registUserSignObserver(self)
    }

}

extension ToDoModule: ToDoProvider {
    
    func getToDoViewController() -> UIViewController? {
        HomeViewController()
    }
    
    func setTaskShared(taskId: String) -> Void {
        TaskManager.shared.shareTask(taskId: taskId)
    }
    
}

extension ToDoModule: UserSignObserver {
    
    func userDidSignOut() {
        TaskManager.shared.homeModel.onNext(nil)
    }
    
}
