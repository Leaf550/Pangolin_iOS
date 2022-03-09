//
//  TaskNavigationTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit
import UIComponents

class TaskNavigationTableViewCell: TaskConfigBaseTableViewCell {
    
    static var reuseID: String = NSStringFromClass(TaskNavigationTableViewCell.self)
    
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
        
        if let titleLabel = titleLabel {
            contentView.addSubview(titleLabel)
        }
        if let currentValueLabel = currentValueLabel {
            contentView.addSubview(currentValueLabel)
        }
        if let IndicatorView = indicatorView {
            contentView.addSubview(IndicatorView)
        }
        if let arrowImageView = arrowImageView {
            contentView.addSubview(arrowImageView)
        }
        
        titleLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(20)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        arrowImageView?.snp.makeConstraints({ make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(15)
        })
        
        currentValueLabel?.snp.makeConstraints({ make in
            if let arrowImageView = arrowImageView {
                make.trailing.equalTo(arrowImageView.snp.leading).offset(-12)
            } else {
                make.trailing.equalToSuperview().offset(-16)
            }
            make.centerY.equalToSuperview()
        })
        
        if let currentValueLabel = currentValueLabel {
            indicatorView?.snp.makeConstraints { make in
                make.trailing.equalTo(currentValueLabel.snp.leading).offset(-10)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(8)
            }
            indicatorView?.layer.cornerRadius = 4
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
