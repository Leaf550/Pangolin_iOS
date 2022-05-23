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
    // 热点
    case hotPoint   = "http://172.20.10.4:8080"
    // 校园网
    case cqupt5g    = "http://10.17.4.220:8080"
    // 生产环境
    case product    = ""
    // Mock环境
    case mock       = "http://127.0.0.1:4523/mock/733201"
}

public enum RequestPath: String {
    // 占位
    case root               = "/"
    // 登录
    case signIn             = "/signIn"
    // 登出
    case signOut            = "/signOut"
    // 注册
    case signUp             = "/signUp"
    // 添加任务分组
    case addGroup           = "/addTaskList"
    // 新增任务
    case addTask            = "/addTask"
    // home页
    case home               = "/home"
    // 完成（取消完成）任务
    case taskCompleted      = "/taskCompleted"
    // 编辑任务
    case editTask           = "/editTask"
    // 删除任务
    case deleteTask         = "/deleteTask"
    // BBS首页
    case bbsHome            = "/getAllBBSPost"
    // 发布帖子
    case createPost         = "/createBBSPost"
    // 上传帖子图片
    case uploadBBSImage     = "/upLoadImage/bbs"
    // 点赞
    case praisePost         = "/praisePost"
    // 评论
    case createComment      = "/createBBSComment"
}
