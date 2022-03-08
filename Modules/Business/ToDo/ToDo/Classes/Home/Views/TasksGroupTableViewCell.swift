//
//  TasksGroupTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/2.
//

import UIKit
import UIComponents

class TasksGroupTableViewCell: TableViewCell {
    
    static let reuseID = NSStringFromClass(TasksGroupTableViewCell.self)
    
    var iconImage: UIImage = UIImage() {
        didSet {
            icon.image = iconImage
        }
    }
    
    var iconColor: TasksGroupIconColor = .blue {
        didSet {
            icon.color = iconColor
        }
    }
    
    var hasSeparateLine: Bool = true {
        didSet {
            self.separateLine.isHidden = !hasSeparateLine
        }
    }
    
    lazy var icon = TasksGroupTinyIcon(image: iconImage, color: iconColor)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textFont(for: .body, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .textFont(for: .body, weight: .regular)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var rightArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow_right")
        return imageView
    }()
    
    private lazy var separateLine: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        line.alpha = 0.5
        return line
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .secondarySystemGroupedBackground
        
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(rightArrow)
        contentView.addSubview(separateLine)
        
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(icon)
            make.leading.equalTo(icon.snp.trailing).offset(16)
        }
        
        rightArrow.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rightArrow)
            make.trailing.equalTo(rightArrow.snp.leading).offset(-10)
        }
        
        separateLine.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
