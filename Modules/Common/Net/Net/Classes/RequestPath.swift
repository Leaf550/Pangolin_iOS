//
//  RequestPath.swift
//  Net
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit

public enum RequestHost: String {
    // 开发环境
    case develop    = "http://127.0.0.1:8080"
    // 生产环境
    case product    = ""
    // Mock环境
    case mock       = "http://127.0.0.1:4523/mock/733201"
}

public enum RequestPath: String {
    // 占位
    case root      = "/"
    // 登录
    case signIn    = "/signIn"
    // 登出
    case signOut   = "/signOut"
    // 注册
    case signUp    = "/signUp"
    // home页
    case home      = "/home"
    // 任务列表页
    case tasksList = "/getTasksInList"
}
