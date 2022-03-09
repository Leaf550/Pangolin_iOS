//
//  TaskSwitchTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit
import UIComponents

class TaskSwitchTableViewCell: TaskConfigBaseTableViewCell {
    
    static var reuseID: String = NSStringFromClass(TaskSwitchTableViewCell.self)
    
    override func setUpSubViews() {
        iconImageView = UIImageView()
        iconImageView?.layer.cornerRadius = 6
        
        titleLabel = UILabel()
        titleLabel?.textColor = .label
        titleLabel?.font = .textFont(for: .body, weight: .regular)
        
        `switch` = UISwitch()
    }
    
}
