//
//  TaskConfigCellModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import PGFoundation
import Persistence
import Provider
import UIComponents

enum AddTaskCellType {
    case input
    case `switch`
    case navigation
}

enum AddTaskCellContent {
    case title
    case comment
    case date
    case time
    case important
    case list
}

class TaskConfigCellModel {
    var type: AddTaskCellType
    var content: AddTaskCellContent
    var textViewText: String?
    var inputPlaceholder: String?
    var titleLabelText: String?
    var iconColor: UIColor?
    var iconImage: UIImage?
    var switchStatus: Bool?
    var currentValueLabelText: String?
    var indicatorViewColor: UIColor?
    
    private var persistenceService = PGProviderManager.shared.provider { PersistenceProvider.self }
    var savedTaskLists: [TaskList]? {
        persistenceService?.getAllTaskLists()
    }
    // 有些地方的入口处可能没有当前列表，例如“今日”、“主页”
    // 所以需要一个默认的选择项
    // 默认是已存储列表的第一个
    lazy var selectedList = savedTaskLists?.first
    
    func defaultValue(task: TaskModel?) -> [[TaskConfigCellModel]] {
        var data = configData(task: task)
        let color: UIColor
        if selectedList != nil {
            color = TasksGroupIconColorImpl.plainColor(with: TasksGroupIconColor(rawValue: selectedList?.listColor ?? 0) ?? .blue)
        } else {
            color = .clear
        }
        data.append([
            navigationCellModel(title: "列表",
                                content: .list,
                                indicatorViewColor: color,
                                currentValue: selectedList?.listName ?? "暂无可用列表")
        ])
        
        return data
    }
    
    private func configData(task: TaskModel?) -> [[TaskConfigCellModel]] {
        return [
            [
                inputCellModel(inputPlaceholder: "标题", textViewText: task?.title, content: .title),
                inputCellModel(inputPlaceholder: "备注", textViewText: task?.comment, content: .comment)
            ],
            [
                switchCellModel(iconColor: .systemRed, content: .date, iconImage: nil, title: "日期", switchStatus: task?.date == nil),
                switchCellModel(iconColor: .systemBlue, content: .time, iconImage: nil, title: "时间", switchStatus: task?.time == nil)
            ],
            [
                switchCellModel(iconColor: .systemOrange, content: .important, iconImage: nil, title: "重要", switchStatus: task?.isImportant ?? false)
            ]
        ]
    }
    
    init(type: AddTaskCellType,
         content: AddTaskCellContent,
         textViewText: String?,
         inputPlaceholder: String?,
         titleLabelText: String?,
         iconColor: UIColor?,
         iconImage: UIImage?,
         switchStatus: Bool?,
         currentValueLabelText: String?,
         indicatorViewColor: UIColor?) {
        self.type = type
        self.content = content
        self.textViewText = textViewText
        self.inputPlaceholder = inputPlaceholder
        self.titleLabelText = titleLabelText
        self.iconColor = iconColor
        self.iconImage = iconImage
        self.switchStatus = switchStatus
        self.currentValueLabelText = currentValueLabelText
        self.indicatorViewColor = indicatorViewColor
    }
    
    init() {
        self.type = .input
        self.content = .title
    }
    
    func inputCellModel(inputPlaceholder: String, textViewText: String?, content: AddTaskCellContent) -> TaskConfigCellModel {
        TaskConfigCellModel(type: .input,
                            content: content,
                            textViewText: textViewText,
                            inputPlaceholder: inputPlaceholder,
                            titleLabelText: nil,
                            iconColor: nil,
                            iconImage: nil,
                            switchStatus: nil,
                            currentValueLabelText: nil,
                            indicatorViewColor: nil)
    }
    
    func switchCellModel(iconColor: UIColor,
                         content: AddTaskCellContent,
                         iconImage: UIImage?,
                         title: String,
                         switchStatus: Bool) -> TaskConfigCellModel {
        TaskConfigCellModel(type: .switch,
                            content: content,
                            textViewText: nil,
                            inputPlaceholder: nil,
                            titleLabelText: title,
                            iconColor: iconColor,
                            iconImage: iconImage,
                            switchStatus: switchStatus,
                            currentValueLabelText: nil,
                            indicatorViewColor: nil)
    }
    
    func navigationCellModel(title: String,
                             content: AddTaskCellContent,
                             indicatorViewColor: UIColor,
                             currentValue: String) -> TaskConfigCellModel {
        TaskConfigCellModel(type: .navigation,
                            content: content,
                            textViewText: nil,
                            inputPlaceholder: nil,
                            titleLabelText: title,
                            iconColor: nil,
                            iconImage: nil,
                            switchStatus: nil,
                            currentValueLabelText: currentValue,
                            indicatorViewColor: indicatorViewColor)
    }
}
