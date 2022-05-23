//
//  MineModule.swift
//  Mine
//
//  Created by 方昱恒 on 2022/5/18.
//

import PGFoundation
import Provider

class MineModule: PGModule {
    
    static var shared: PGModule = MineModule()
    
    func runModule() {
        PGProviderManager.shared.registerProvider({ MineProvider.self }, self)
    }
    
    deinit {
        PGProviderManager.shared.deregisterProvider { MineProvider.self }
    }
    
}

extension MineModule: MineProvider {
    
    func getMineViewController() -> UIViewController? {
        return MineViewController()
    }
    
}
