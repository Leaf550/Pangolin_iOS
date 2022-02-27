//
//  AccountProvider.swift
//  Provider
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit

public protocol AccountProvider: PGProvider {
    
    func presentLoginViewController(from controller: UIViewController,
                                    animated: Bool,
                                    completion: (() -> Void)?)
    
}

extension AccountProvider {
    
    public func presentLoginViewController(from controller: UIViewController,
                                    animated: Bool) {
        self.presentLoginViewController(from: controller, animated: animated, completion: nil)
    }
    
}
