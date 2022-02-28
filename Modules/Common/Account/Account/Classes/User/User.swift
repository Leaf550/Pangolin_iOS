//
//  User.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/28.
//

//   let user = try? newJSONDecoder().decode(User.self, from: jsonData)

import Foundation

// MARK: - User
public struct User: Codable {
    // 用户唯一ID
    var sub: String?
    // 登录用户名（唯一）
    var username: String?
    // 等级
    var level: Int?
    // 经验值
    var experience: Int?
    // 登录过期时间
    var exp: Int?
}
