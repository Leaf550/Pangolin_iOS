//
//  BBSModule.swift
//  BBS
//
//  Created by 方昱恒 on 2022/2/27.
//

import PGFoundation
import Provider

class BBSModule: PGModule {
    
    public static var shared: PGModule = BBSModule()
    
    func runModule() {
         PGProviderManager.shared.registerProvider({ BBSProvider.self }, self)
    }
    
    deinit {
         PGProviderManager.shared.deregisterProvider({ BBSProvider.self })
    }

}

extension BBSModule: BBSProvider {
    
    func getBBSViewController() -> UIViewController? {
        return BBSViewController()
    }
    
}

