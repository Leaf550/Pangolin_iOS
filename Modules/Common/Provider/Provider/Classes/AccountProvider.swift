//
//  AccountProvider.swift
//  Provider
//
//  Created by 方昱恒 on 2022/2/27.
//

import PGFoundation

public protocol UserSignObserver {
    func userDidSignIn()
    func userDidSignOut()
}

public extension UserSignObserver {
    func userDidSignIn() {}
    func userDidSignOut() {}
}

public protocol AccountProvider: PGProvider {
    
    func presentLoginViewController(from controller: UIViewController,
                                    animated: Bool,
                                    presentCompletion: (() -> Void)?,
                                    loginCompletion: ((Bool) -> Void)?)
    func getToken() -> String?
    func getUser() -> User?
    func isLogined() -> Bool
    func logout()
    
    func registUserSignObserver(_ observer: UserSignObserver)
}

extension AccountProvider {
    
    public func presentLoginViewController(from controller: UIViewController,
                                    animated: Bool) {
        self.presentLoginViewController(from: controller,
                                        animated: animated,
                                        presentCompletion: nil,
                                        loginCompletion: nil)
    }
    
}
