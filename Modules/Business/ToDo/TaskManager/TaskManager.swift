//
//  TaskManager.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/4/13.
//

import PGFoundation
import Provider
import RxSwift

class TaskManager {
    
    static let shared = TaskManager()
    
    var persistenceService = PGProviderManager.shared.provider(forProtocol: { PersistenceProvider.self })
    
    var persistedHomeModel: HomeModel? {
        persistenceService?.getHomeModel()
    }
    
    lazy var homeModel: BehaviorSubject<HomeModel?> = BehaviorSubject<HomeModel?>(value: persistedHomeModel)
    
}
