//
//  User.swift
//  PGFoundation
//
//  Created by 方昱恒 on 2022/3/16.
//

import Foundation

public protocol User {
    // 用户唯一ID
    var sub: String? { get set }
    // 登录用户名（唯一）
    var username: String? { get set }
    // 等级
    var level: Int? { get set }
    // 经验值
    var experience: Int? { get set }
    // 登录过期时间
    var exp: Int? { get set }
}
