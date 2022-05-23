//
//  GroupIconImageCollectionViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/9.
//

import UIKit

class GroupIconImageCollectionViewCell: GroupIconBaseCollectionViewCell {
    
    static let reuseID: String = NSStringFromClass(GroupIconImageCollectionViewCell.self)
    
    private lazy var iconBackgroundView = UIView()
    
    override func setUpSubViews() {
        imageView = UIImageView()
        imageView?.tintColor = .darkGray
        contentView.addSubview(iconBackgroundView)
        
        iconBackgroundView.backgroundColor = .tertiarySystemGroupedBackground
        iconBackgroundView.addSubview(imageView ?? UIImageView())
        
        contentView.layer.cornerRadius = (frame.width - 10) * 0.5 + 5
        iconBackgroundView.layer.cornerRadius = (frame.width - 10) * 0.5
        iconBackgroundView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(5)
            make.bottom.trailing.equalToSuperview().offset(-5)
        }
        
        imageView?.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(25)
        }
    }
    
}
