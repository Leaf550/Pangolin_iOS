//
//  TaskModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/4.
//

import PGFoundation
import RxDataSources

extension TaskModel: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String {
        taskID ?? UUID().uuidString
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.taskID ?? UUID().uuidString == rhs.taskID ?? UUID().uuidString
    }
}

extension TasksListSection: AnimatableSectionModelType {
    var items: [TaskModel] {
        tasks ?? []
    }
    
    typealias Identity = String
    
    init(original: TasksListSection, items: [TaskModel]) {
        self = original
        self.tasks = items
    }
    
    var identity: String {
        taskList?.listID ?? UUID().uuidString
    }
}
