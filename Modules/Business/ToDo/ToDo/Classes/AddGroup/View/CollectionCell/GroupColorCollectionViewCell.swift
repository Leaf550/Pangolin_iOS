//
//  GroupColorCollectionViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/9.
//

import UIKit
import Util
import SnapKit
import UIComponents

class GroupColorCollectionViewCell: GroupIconBaseCollectionViewCell {
    
    static let reuseID: String = NSStringFromClass(GroupColorCollectionViewCell.self)
    
    override func setUpSubViews() {
        colorView = UIView()
        colorView?.backgroundColor = .red
        
        contentView.addSubview(colorView ?? UIView())
        
        contentView.layer.cornerRadius = (frame.width - 10) * 0.5 + 5
        colorView?.layer.cornerRadius = (frame.width - 10) * 0.5
        colorView?.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(5)
            make.bottom.trailing.equalToSuperview().offset(-5)
        }
    }
    
}
