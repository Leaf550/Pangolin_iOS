//
//  PersistenceModule.swift
//  PersistenceModule
//
//  Created by 方昱恒 on 2022/3/19.
//

import PGFoundation
import Provider

class PersistenceModule: PGModule {
    
    static var shared: PGModule = PersistenceModule()
    
    let accountKV = KV(field: .account)
    let globalKV = KV(field: .global)
    
    func runModule() {
        PGProviderManager.shared.registerProvider({ PersistenceProvider.self }, self)
    }

    deinit {
        PGProviderManager.shared.deregisterProvider({ PersistenceProvider.self })
    }
    
}

extension PersistenceModule: PersistenceProvider {
    
    // MARK: - User
    func saveUser<U>(_ user: U) -> Bool where U : User, U : Decodable, U : Encodable {
        accountKV.set(user, forKey: PersistenceKVKey.userKVKey)
    }
    
    func getUser<U>() -> U? where U : User, U : Decodable, U : Encodable {
        accountKV.object(U.self, forKey: PersistenceKVKey.userKVKey)
    }
    
    func saveToken(_ token: String) -> Bool {
        accountKV.set(token, forKey: PersistenceKVKey.tokenKVKey)
    }
    
    func getToken() -> String? {
        accountKV.string(forKey: PersistenceKVKey.tokenKVKey, defaultValue: nil)
    }
    
    // MARK: - HomeModel
    func saveHomeModel(_ homeModel: HomeModel) -> Bool {
        accountKV.set(homeModel, forKey: PersistenceKVKey.homeModelKVKey)
    }
    
    func getHomeModel() -> HomeModel? {
        accountKV.object(HomeModel.self, forKey: PersistenceKVKey.homeModelKVKey)
    }
    
    // MARK: - TaskLists
    func getAllTaskLists() -> [TaskList]? {
        guard let homeModel = getHomeModel() else { return nil }
        let lists = homeModel.data?.otherList?
            .map { $0.sections?.first?.taskList }
            .filter { $0 != nil }
        return lists as? [TaskList]
    }
    
}
