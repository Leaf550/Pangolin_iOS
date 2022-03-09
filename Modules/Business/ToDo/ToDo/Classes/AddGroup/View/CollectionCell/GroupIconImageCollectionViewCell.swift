//
//  GroupIconImageCollectionViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/9.
//

import UIKit

class GroupIconImageCollectionViewCell: GroupIconBaseCollectionViewCell {
    
    static let reuseID: String = NSStringFromClass(GroupIconImageCollectionViewCell.self)
    
    override func setUpSubViews() {
        imageView = UIImageView()
        imageView?.backgroundColor = .tertiarySystemGroupedBackground
        
        contentView.addSubview(imageView ?? UIImageView())
        
        contentView.layer.cornerRadius = (frame.width - 10) * 0.5 + 5
        imageView?.layer.cornerRadius = (frame.width - 10) * 0.5
        imageView?.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(5)
            make.bottom.trailing.equalToSuperview().offset(-5)
        }
    }
    
}
