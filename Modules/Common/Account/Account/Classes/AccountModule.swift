//
//  AccountModule.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/27.
//

import PGFoundation
import Provider

class AccountModule: PGModule {
    
    public static var shared: PGModule = AccountModule()
    
    func runModule() {
        PGProviderManager.shared.registerProvider({ AccountProvider.self }, self)
    }

    deinit {
        PGProviderManager.shared.deregisterProvider({ AccountProvider.self })
    }
    
}

extension AccountModule: AccountProvider {
    
    func presentLoginViewController(from controller: UIViewController,
                                    animated: Bool,
                                    completion: (() -> Void)?) {
        let loginViewController = LoginViewController(viewModel: LoginViewModel())
        controller.present(loginViewController,
                           animated: animated,
                           completion: completion)
    }
    
}
