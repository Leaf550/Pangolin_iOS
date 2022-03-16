//
//  UserImpl.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/28.
//

//   let user = try? newJSONDecoder().decode(UserImpl.self, from: jsonData)

import PGFoundation

// MARK: - User
class UserImpl: NSObject, Codable, User {
    // 用户唯一ID
    public var sub: String?
    // 登录用户名（唯一）
    public var username: String?
    // 等级
    public var level: Int?
    // 经验值
    public var experience: Int?
    // 登录过期时间
    public var exp: Int?
}
