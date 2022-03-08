//
//  TaskConfigCellModel.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit

enum TaskCellType {
    case input
    case `switch`
    case navigation
}

struct TaskConfigCellModel {
    var type: TaskCellType
    var inputPlaceholder: String?
    var titleLabelText: String?
    var iconColor: UIColor?
    var iconImage: UIImage?
    var switchStatus: Bool?
    var currentValueLabelText: String?
    var indicatorViewColor: UIColor?
    
    static func inputCellModel(inputPlaceholder: String) -> TaskConfigCellModel {
        TaskConfigCellModel(type: .input,
                            inputPlaceholder: inputPlaceholder,
                            titleLabelText: nil,
                            iconColor: nil,
                            iconImage: nil,
                            switchStatus: nil,
                            currentValueLabelText: nil,
                            indicatorViewColor: nil)
    }
    
    static func switchCellModel(iconColor: UIColor,
                                iconImage: UIImage?,
                                title: String,
                                switchStatus: Bool) -> TaskConfigCellModel {
        TaskConfigCellModel(type: .switch,
                            inputPlaceholder: nil,
                            titleLabelText: title,
                            iconColor: iconColor,
                            iconImage: iconImage,
                            switchStatus: switchStatus,
                            currentValueLabelText: nil,
                            indicatorViewColor: nil)
    }
    
    static func navigationCellModel(title: String,
                                    indicatorViewColor: UIColor,
                                    currentValue: String) -> TaskConfigCellModel {
        TaskConfigCellModel(type: .navigation,
                            inputPlaceholder: nil,
                            titleLabelText: title,
                            iconColor: nil,
                            iconImage: nil,
                            switchStatus: nil,
                            currentValueLabelText: currentValue,
                            indicatorViewColor: indicatorViewColor)
    }
    
    static func defaultValue() -> [[TaskConfigCellModel]] {
        [
            [
                inputCellModel(inputPlaceholder: "标题"),
                inputCellModel(inputPlaceholder: "备注")
            ],
            [
                switchCellModel(iconColor: .systemRed, iconImage: nil, title: "日期", switchStatus: false),
                switchCellModel(iconColor: .systemBlue, iconImage: nil, title: "时间", switchStatus: false)
            ],
            [
                switchCellModel(iconColor: .systemOrange, iconImage: nil, title: "重要", switchStatus: false)
            ],
            [
                navigationCellModel(title: "列表",
                                    indicatorViewColor: .systemBlue,
                                    currentValue: "1")
            ]
        ]
    }
}
