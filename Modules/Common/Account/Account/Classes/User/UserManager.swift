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
    
    public var user: User?
    
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
    
    func login(withToken token: String, completion: (User?, String?) -> Void) {
        guard !isLogined else {
            completion(nil, "已经登录过了")
            return
        }
        parseToken(token) { [weak self] user, message in
            if let user = user {
                self?.token = token
                self?.user = user
                completion(user, nil)
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
    
    private func parseToken(_ token: String, completion: (User?, String?) -> Void) {
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
        guard let user = try? JSONDecoder().decode(User.self, from: data) else {
            completion(nil, "bad token")
            return
        }
        
        completion(user, nil)
    }
    
}
