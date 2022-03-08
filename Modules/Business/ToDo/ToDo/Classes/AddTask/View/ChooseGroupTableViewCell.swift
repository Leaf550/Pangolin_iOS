//
//  ChooseGroupTableViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/8.
//

import UIKit
import UIComponents

class ChooseGroupTableViewCell: TableViewCell {
    
    static let reuseID = NSStringFromClass(ChooseGroupTableViewCell.self)
    
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
    
    lazy var icon = TasksGroupTinyIcon(image: iconImage, color: iconColor)
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textFont(for: .body, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private lazy var separateLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.alpha = 0.5
        return line
    }()
    
    private lazy var tickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tick")
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTickImageHidden(_ isHidden: Bool) {
        tickImageView.isHidden = isHidden
    }
    
    private func configSubViews() {
        style = .fillEnds
        
        contentView.backgroundColor = .clear
        
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(tickImageView)
        contentView.addSubview(separateLine)
        
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(11)
            make.bottom.equalToSuperview().offset(-11)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(icon)
            make.leading.equalTo(icon.snp.trailing).offset(16)
        }
        
        tickImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        separateLine.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
}
