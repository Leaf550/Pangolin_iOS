//
//  HomeModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/15.
//

//   let homeModel = try? newJSONDecoder().decode(HomeModel.self, from: jsonData)

import Foundation

// MARK: - HomeModel
struct HomeModel: Codable {
    var status: Int?
    var data: HomeData?
    var message: String?
}

// MARK: - HomeData
struct HomeData: Codable {
    var todayCount, importantCount, allCount, completedCount: Int?
    var today, important, all, completed: ListPageData?
    var otherList: [ListPageData]?
}

// MARK: - ListPageData
struct ListPageData: Codable {
    var sections: [TasksListSection]?
}

// MARK: - TasksListSection
struct TasksListSection: Codable {
    var taskList: TaskList?
    var tasks: [TaskModel]?
}

// MARK: - TaskList
struct TaskList: Codable {
    var listID: String?
    var uid: String?
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

// MARK: - TaskModel
struct TaskModel: Codable {
    var uid: String?
    var taskID, title: String?
    var comment: String?
    var date, time: Double?
    var createTime, priority: Int?
    var listID: String?
    var isCompleted, isImportant: Bool?

    enum CodingKeys: String, CodingKey {
        case uid
        case taskID = "taskId"
        case title, comment, date, time, createTime, priority
        case listID = "listId"
        case isCompleted, isImportant
    }
}
