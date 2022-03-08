//
//  TaskArrowTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit
import UIComponents

class TaskArrowTableViewCell: TaskConfigBaseTableViewCell {
    
    static var reuseID: String = NSStringFromClass(TaskArrowTableViewCell.self)
    
    override func setUpSubViews() {
        titleLabel = UILabel()
        titleLabel?.textColor = .label
        titleLabel?.font = .textFont(for: .body, weight: .regular)
        
        currentValueLabel = UILabel()
        currentValueLabel?.textColor = .secondaryLabel
        currentValueLabel?.font = .textFont(for: .body, weight: .regular)
        
        indicatorView = UIView()
        
        arrowImageView = UIImageView()
        arrowImageView?.image = UIImage(named: "arrow_right")
        
        super.setUpSubViews()
    }
    
}
