//
//  HomeModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/19.
//

import Foundation

// MARK: - HomeModel
public struct HomeModel: Codable {
    public var status: Int?
    public var data: HomeData?
    public var message: String?
}

public struct HomeData: Codable {
    public var todayCount, importantCount, allCount, completedCount: Int?
    public var today, important, all, completed: ListPageData?
    public var otherList: [ListPageData]?
}

public struct ListPageData: Codable {
    public var sections: [TasksListSection]?
}

public struct TasksListSection: Codable {
    public var taskList: TaskList?
    public var tasks: [TaskModel]?
}

public struct TaskModel: Codable {
    public var uid: String?
    public var taskID, title: String?
    public var comment: String?
    public var date, time: Double?
    public var createTime, priority: Int?
    public var listID: String?
    public var isCompleted, isImportant: Bool?

    enum CodingKeys: String, CodingKey {
        case uid
        case taskID = "taskId"
        case title, comment, date, time, createTime, priority
        case listID = "listId"
        case isCompleted, isImportant
    }
}

public struct TaskList: Codable {
    public var listID: String?
    public var uid: String?
    public var listType: Int?
    public var listName: String?
    public var listColor: Int?
    public var imageName: String?
    public var taskCount, completedCount, createTime, sortedBy: Int?

    enum CodingKeys: String, CodingKey {
        case listID = "listId"
        case uid, listType, listName, listColor, imageName, taskCount, completedCount, createTime, sortedBy
    }
}



