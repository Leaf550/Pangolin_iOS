//
//  BBSHomeModel.swift
//  BBS
//
//  Created by 方昱恒 on 2022/4/14.
//

import PGFoundation

// MARK: - BBSHomeModel
struct BBSHomeModel: Codable {
    let status: Int?
    let data: BBSHomeModelData?
    let message: String?
}

// MARK: - BBSHomeModelData
struct BBSHomeModelData: Codable {
    let posts: [BBSPost]?
}

// MARK: - BBSPost
struct BBSPost: Codable {
    let postID: String?
    let author: UserImpl?
    let createTime: Int?
    let content: String?
    let task: TaskModel?
    let praiseCount: Int?
    let commentList: [BBSComment]?
    let imageUrls: [String]?
    let isPraised: Bool?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case author, createTime, content, task
        case praiseCount, commentList, imageUrls
        case isPraised = "praised"
    }
}

// MARK: - BBSComment
struct BBSComment: Codable {
    let commentID, postID: String?
    let sourceUser: UserImpl?
    let targetUser: UserImpl?
    let createTime: Int?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case commentID = "commentId"
        case postID = "postId"
        case sourceUser, targetUser, createTime, content
    }
}
