//
//  UserManager.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/28.
//

import Util

public class UserManager {
    
    public static let shared = UserManager()
    
    private var token: String?
    
    public func getToken() -> String? { token }
    
    public var isLogined: Bool {
        user != nil && !isLoginExpiration
    }
    
    public var isLoginExpiration: Bool {
        guard let user = user else { return true }
        let exp = user.exp ?? 0
        let timestamp = Date().timeIntervalSince1970
        return timestamp > Double(exp)
    }
    
    public var user: User? {
        guard let token = token else { return nil }
        return parseToken(token)
    }
    
    func login(withToken token: String) -> User? {
        guard isLogined else { return nil }
        guard let user = parseToken(token) else { return nil }
        self.token = token
        return user
    }
    
    private func parseToken(_ token: String) -> User? {
        guard let decoded = Cycriptor.base64Decode(encoded: token) else { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: decoded) else { return nil }
        guard let user = try? JSONDecoder().decode(User.self, from: data) else { return nil }
        
        return user
    }
    
}
