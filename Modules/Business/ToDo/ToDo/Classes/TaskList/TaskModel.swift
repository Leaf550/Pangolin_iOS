//
//  TaskModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/4.
//

import PGFoundation
import RxDataSources

struct TaskModel: Model {
    var isSelected: Bool
    var text: String
}

extension TaskModel: IdentifiableType, Equatable {
    
    typealias Identity = String
    
    var identity: String {
        text
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.text == rhs.text
    }
    
}

struct TasksListSection {
    var header: String
    var items: [TaskModel]
}

extension TasksListSection: AnimatableSectionModelType {
    
    typealias Identity = String
    
    init(original: TasksListSection, items: [TaskModel]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        header
    }
    
}
