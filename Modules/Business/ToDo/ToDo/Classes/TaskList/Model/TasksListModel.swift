//
//  TaskModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/4.
//

import PGFoundation
import RxDataSources

extension TaskModel: IdentifiableType, Equatable {
    public typealias Identity = String
    
    public var identity: String {
        taskID ?? UUID().uuidString
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.taskID ?? UUID().uuidString == rhs.taskID ?? UUID().uuidString
    }
}

extension TasksListSection: AnimatableSectionModelType {
    public var items: [TaskModel] {
        tasks ?? []
    }
    
    public typealias Identity = String
    
    public init(original: TasksListSection, items: [TaskModel]) {
        self = original
        self.tasks = items
    }
    
    public var identity: String {
        taskList?.listID ?? UUID().uuidString
    }
}

extension TasksListSection: Hashable {
    
    public var hashValue: Int {
        Int(arc4random())
    }
    
    public static func == (lhs: TasksListSection, rhs: TasksListSection) -> Bool {
        lhs.identity == rhs.identity
    }
}
