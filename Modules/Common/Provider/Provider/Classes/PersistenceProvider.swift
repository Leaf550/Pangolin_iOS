//
//  PersistenceProvider.swift
//  Provider
//
//  Created by 方昱恒 on 2022/3/19.
//

import PGFoundation

public protocol PersistenceProvider: PGProvider {
    
    // User
    func saveUser<U: User & Codable>(_ user: U) -> Bool
    func getUser<U: User & Codable>() -> U?
    func saveToken(_ token: String) -> Bool
    func getToken() -> String?
    
    // HomeModel
    func saveHomeModel(_ homeModel: HomeModel) -> Bool
    func getHomeModel() -> HomeModel?
    
    // TaskLists
    func getAllTaskLists() -> [TaskList]?
    
}
