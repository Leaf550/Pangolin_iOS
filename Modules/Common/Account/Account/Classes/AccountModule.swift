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
    
    var signObservers = [UserSignObserver]()
    
    private let persistenceService = PGProviderManager.shared.provider { PersistenceProvider.self }
    
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
    
    func isLogined() -> Bool {
        UserManager.shared.isLogined
    }
    
    func logout() {
        UserManager.shared.clearUserInfo()
        for signObserver in signObservers {
            signObserver.userDidSignOut()
        }
    }
    
    func registUserSignObserver(_ observer: UserSignObserver) {
        signObservers.append(observer)
    }
    
}
