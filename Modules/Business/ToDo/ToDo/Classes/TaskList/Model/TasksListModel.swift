//
//  TaskModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/4.
//

import PGFoundation
import RxDataSources

//   let tasksListModel = try? newJSONDecoder().decode(TasksListModel.self, from: jsonData)

// MARK: - TasksListModel
struct TasksListModel: Model, Codable {
    var status: Int?
    var data: TasksListData?
    var message: String?
}

// MARK: - TasksListData
struct TasksListData: Codable {
    var sections: [TasksListSection]?
}

struct TaskModel: Codable {
    var uid, taskID, title, comment: String?
    var date, time: Double?
    var isImportant, isCompleted: Bool?
    var createTime, priority: Int?
    var listID, listName: String?
    var listColor: Int?

    enum CodingKeys: String, CodingKey {
        case uid
        case taskID = "taskId"
        case title, comment, date, time, isImportant, isCompleted, createTime, priority
        case listID = "listId"
        case listName, listColor
    }
}

extension TaskModel: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String {
        taskID ?? UUID().uuidString
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.taskID ?? UUID().uuidString == rhs.taskID ?? UUID().uuidString
    }
}

struct TasksListSection: Codable {
    var header: String
    var tasks: [TaskModel]
}

extension TasksListSection: AnimatableSectionModelType {
    var items: [TaskModel] {
        tasks
    }
    
    typealias Identity = String
    
    init(original: TasksListSection, items: [TaskModel]) {
        self = original
        self.tasks = items
    }
    
    var identity: String {
        header
    }
}
