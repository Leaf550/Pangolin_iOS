//
//  UserManager.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/28.
//

import Util
import Provider

class UserManager {
    
    static let shared = UserManager()
        
    func getToken() -> String? { token }
    
    func getUser() -> UserImpl? { user }
    
    var isLogined: Bool {
        user != nil && !isLoginExpiration
    }
    
    var isLoginExpiration: Bool {
        guard let user = user else { return true }
        let exp = user.exp ?? 0
        let timestamp = Date().timeIntervalSince1970
        return timestamp > Double(exp)
    }
    
    var token: String?
    var user: UserImpl?
    
    private let persistenceProvider = PGProviderManager.shared.provider { PersistenceProvider.self }
    
    func login(withToken token: String, completion: (UserImpl?, String?) -> Void) {
        guard !isLogined else {
            completion(nil, "已经登录过了")
            return
        }
        parseToken(token) { [weak self] user, message in
            if let user = user {
                self?.token = token
                self?.user = user
                if self?.persistenceProvider?.saveUser(user) ?? false
                    && self?.persistenceProvider?.saveToken(token) ?? false {
                    completion(user, nil)
                } else {
                    completion(nil, "用户数据存储失败")
                }
            }
            if let message = message {
                completion(nil, message)
            }
        }
    }
    
    func logout() {
        self.token = nil
        self.user = nil
    }
    
    private func parseToken(_ token: String, completion: (UserImpl?, String?) -> Void) {
        let seq = token.split(separator: Character("."))
        if seq.count < 3 {
            completion(nil, "bad token")
            return
        }
        let payload = String(seq[1])
        guard let decoded = Cycriptor.base64Decode(encoded: payload) else {
            completion(nil, "bad token")
            return
        }
        guard let data = try? JSONSerialization.data(withJSONObject: decoded) else {
            completion(nil, "bad token")
            return
        }
        guard let user = try? JSONDecoder().decode(UserImpl.self, from: data) else {
            completion(nil, "bad token")
            return
        }
        
        completion(user, nil)
    }
    
}
