//
//  HomeModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/15.
//

//   let homeModel = try? newJSONDecoder().decode(HomeModel.self, from: jsonData)

import PGFoundation

// MARK: - HomeModel
struct HomeModel: Codable {
    var status: Int?
    var data: HomeData?
    var message: String?
}

// MARK: - DataClass
struct HomeData: Codable {
    var today, important, all, completed: Int?
    var taskLists: [TaskList]?
}

// MARK: - TaskList
struct TaskList: Codable {
    var listID, uid: String?
    var listType: Int?
    var listName: String?
    var listColor: Int?
    var imageName: String?
    var taskCount, completedCount, createTime, sortedBy: Int?

    enum CodingKeys: String, CodingKey {
        case listID = "listId"
        case uid, listType, listName, listColor, imageName, taskCount, completedCount, createTime, sortedBy
    }
}
