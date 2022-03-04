//
//  ToDoModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/4.
//

import PGFoundation
import RxDataSources

struct ToDoModel: Model {
    var isSelected: Bool
    var text: String
}

extension ToDoModel: IdentifiableType, Equatable {
    
    typealias Identity = String
    
    var identity: String {
        text
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.text == rhs.text
    }
    
}

struct ToDoListSection {
    var header: String
    var items: [ToDoModel]
}

extension ToDoListSection: AnimatableSectionModelType {
    
    typealias Identity = String
    
    init(original: ToDoListSection, items: [ToDoModel]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        header
    }
    
}
