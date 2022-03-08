//
//  TaskConfigBaseTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit
import UIComponents
import SnapKit

class TaskConfigBaseTableViewCell: TableViewCell {
    
    var textView: TextView?
    var titleLabel: UILabel?
    var iconImageView: UIImageView?
    var `switch`: UISwitch?
    var currentValueLabel: UILabel?
    var indicatorView: UIView?
    var arrowImageView: UIImageView?
    
    var tableView: UITableView?
    
    private lazy var separateLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.style = .fillEnds
        contentView.backgroundColor = .secondarySystemGroupedBackground
        
        setUpSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIsSeparateLineHidden(_ hidden: Bool) {
        separateLine.isHidden = hidden
    }
    
    func setUpSubViews() {
        addSubViewsConstraints()
    }
    
    private func addSubViewsConstraints() {
        if let input = textView {
            contentView.addSubview(input)
        }
        if let titleLabel = titleLabel {
            contentView.addSubview(titleLabel)
        }
        if let iconImageView = iconImageView {
            contentView.addSubview(iconImageView)
        }
        if let `switch` = `switch` {
            contentView.addSubview(`switch`)
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
        contentView.addSubview(separateLine)
        
        textView?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(38)
        }
        
        titleLabel?.snp.makeConstraints { make in
            if let iconImageView = iconImageView {
                make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            } else {
                make.leading.equalToSuperview().offset(16)
                make.height.equalTo(20)
                make.top.equalToSuperview().offset(12)
                make.bottom.equalToSuperview().offset(-12)
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
        
        separateLine.snp.makeConstraints { make in
            if let titleLabel = titleLabel {
                make.leading.equalTo(titleLabel)
            } else if let textView = textView {
                make.leading.equalTo(textView)
            } else {
                make.leading.equalTo(16)
            }
            make.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    func configCell(with model: TaskConfigCellModel) {
        textView?.placeholder = model.inputPlaceholder
        titleLabel?.text = model.titleLabelText
        iconImageView?.backgroundColor = model.iconColor
        iconImageView?.image = model.iconImage
        `switch`?.isOn = model.switchStatus ?? false
        currentValueLabel?.text = model.currentValueLabelText
        indicatorView?.backgroundColor = model.indicatorViewColor
    }
    
}
