//
//  TaskSwitchTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit
import UIComponents
import RxSwift
import RxCocoa

class TaskSwitchTableViewCell: TaskConfigBaseTableViewCell {
    
    static var reuseID: String = NSStringFromClass(TaskSwitchTableViewCell.self)
    
    private lazy var disposeBag = DisposeBag()
    
    override func setUpSubViews() {
        iconImageView = UIImageView()
        iconImageView?.layer.cornerRadius = 6
        
        titleLabel = UILabel()
        titleLabel?.textColor = .label
        titleLabel?.font = .textFont(for: .body, weight: .regular)
        
        datePicker = UIDatePicker()
        datePicker?.timeZone = TimeZone.current
        datePicker?.locale = Locale(identifier: "zh_CN")
        
        `switch` = UISwitch()
        `switch`?.rx.isOn.subscribe(onNext: { [weak self] isOn in
            if let contentType = self?.contentType,
               contentType == .date || contentType == .time {
                self?.datePicker?.isHidden = !isOn
            }
        }).disposed(by: disposeBag)
        
        if let titleLabel = titleLabel {
            contentView.addSubview(titleLabel)
        }
        if let iconImageView = iconImageView {
            contentView.addSubview(iconImageView)
        }
        if let `switch` = `switch` {
            contentView.addSubview(`switch`)
        }
        if let datePicker = datePicker {
            contentView.addSubview(datePicker)
        }
        
        titleLabel?.snp.makeConstraints { make in
            if let iconImageView = iconImageView {
                make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            } else {
                make.leading.equalToSuperview()
            }
            make.centerY.equalToSuperview()
        }
        
        if let iconImageView = iconImageView,
           let `switch` = `switch`,
           let datePicker = datePicker {
            iconImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.top.equalToSuperview().offset(14)
                make.width.height.equalTo(29)
                make.bottom.equalToSuperview().offset(-14)
            }
            
            datePicker.snp.makeConstraints { make in
                make.trailing.equalTo(`switch`.snp.leading).offset(-14)
                make.centerY.equalTo(`switch`)
            }
        }
        
        if let `switch` = `switch` {
            `switch`.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-14)
                make.centerY.equalToSuperview()
            }
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
