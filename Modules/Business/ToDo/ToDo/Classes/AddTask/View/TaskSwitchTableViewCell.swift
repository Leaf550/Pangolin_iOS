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
        
        if let titleLabel = titleLabel {
            contentView.addSubview(titleLabel)
        }
        if let iconImageView = iconImageView {
            contentView.addSubview(iconImageView)
        }
        if let `switch` = `switch` {
            contentView.addSubview(`switch`)
        }
        
        titleLabel?.snp.makeConstraints { make in
            if let iconImageView = iconImageView {
                make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            } else {
                make.leading.equalToSuperview()
            }
            make.centerY.equalToSuperview()
        }
        
        iconImageView?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-14)
            make.width.height.equalTo(29)
        }
        
        `switch`?.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-14)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(separateLine)
        separateLine.snp.makeConstraints { make in
            if let titleLabel = titleLabel {
                make.leading.equalTo(titleLabel)
            } else {
                make.leading.equalToSuperview().offset(16)
            }
            make.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
}
