//
//  ToDoListCellTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/2.
//

import UIKit
import UIComponents

public class ToDoListCellTableViewCell: TableViewCell {
    
    public var iconImage: UIImage = UIImage() {
        didSet {
            icon.image = iconImage
        }
    }
    
    public var iconColor: ToDoIconColor = .blue {
        didSet {
            icon.color = iconColor
        }
    }
    
    public var hasSeparateLine: Bool = true {
        didSet {
            self.separateLine.isHidden = !hasSeparateLine
        }
    }
    
    public lazy var icon = ToDoTinyIcon(image: iconImage, color: iconColor)
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textFont(for: .body, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    public lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .textFont(for: .body, weight: .regular)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private lazy var rightArrow: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var separateLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        
        return line
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
            make.width.equalTo(6)
            make.height.equalTo(9)
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
    
    public static let reuseID = NSStringFromClass(ToDoListCellTableViewCell.self)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
