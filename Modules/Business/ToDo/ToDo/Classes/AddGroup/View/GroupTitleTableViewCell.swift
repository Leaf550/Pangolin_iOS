//
//  GroupTitleTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/9.
//

import UIKit
import UIComponents

class GroupTitleTableViewCell: GroupConfigBaseTableViewCell {
    
    static var reuseID: String = NSStringFromClass(GroupTitleTableViewCell.self)
    
    var textFieldTextColor: TasksGroupIconColor = .red {
        didSet {
            groupTitleTextTield?.textColor = TasksGroupIconColorImpl.plainColor(with: textFieldTextColor)
        }
    }
    
    override func setUpSubViews() {
        super.setUpSubViews()
        
        groupIcon = TasksGroupLargeIcon(image: UIImage(), backgroundColor: .red)
        
        groupTitleTextTield = UITextField()
        groupTitleTextTield?.placeholder = "列表名称"
        groupTitleTextTield?.font = .textFont(for: .title2, weight: .medium)
        groupTitleTextTield?.textColor = TasksGroupIconColorImpl.plainColor(with: textFieldTextColor)
        groupTitleTextTield?.textAlignment = .center
        groupTitleTextTield?.backgroundColor = .tertiarySystemGroupedBackground
        groupTitleTextTield?.layer.cornerRadius = 10
    }
    
}
