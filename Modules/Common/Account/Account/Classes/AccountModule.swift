//
//  AccountModule.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/27.
//

import PGFoundation
import Provider
import KV

class AccountModule: PGModule {
    
    public static var shared: PGModule = AccountModule()
    
    func runModule() {
        PGProviderManager.shared.registerProvider({ AccountProvider.self }, self)
    }

    deinit {
        PGProviderManager.shared.deregisterProvider({ AccountProvider.self })
    }
    
    func applicationWillFinishLaunching() {
        if let token = KV().string(forKey: UserManager.shared.tokenMMKVKey) {
            UserManager.shared.token = token
        }
        if let user = KV().object(UserImpl.self, forKey: UserManager.shared.userMMKVKey) {
            UserManager.shared.user = user
        }
    }
    
}

extension AccountModule: AccountProvider {
    
    func presentLoginViewController(from controller: UIViewController,
                                    animated: Bool,
                                    presentCompletion: (() -> Void)?,
                                    loginCompletion: ((Bool) -> Void)?) {
        let loginViewController = LoginViewController(viewModel: LoginViewModel())
        loginViewController.loginCompletion = loginCompletion ?? { _ in }
        controller.present(loginViewController,
                           animated: animated,
                           completion: presentCompletion)
    }
    
    func getToken() -> String? {
        UserManager.shared.getToken()
    }
    
    func getUser() -> User? {
        UserManager.shared.getUser()
    }
    
    
}
