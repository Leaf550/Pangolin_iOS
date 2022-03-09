//
//  GroupIconBaseCollectionViewCell.swift
//  ToDo
//
//  Created by 方昱恒 on 2022/3/9.
//

import UIKit
import UIComponents

class GroupIconBaseCollectionViewCell: UICollectionViewCell {
    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
    
    var color: TasksGroupIconColor = .red {
        didSet {
            colorView?.backgroundColor = TasksGroupIconColorImpl.plainColor(with: color)
        }
    }
    
    var imageView: UIImageView?
    var colorView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubViews() {
        fatalError("setUpSubViews() has not been implemented")
    }
    
    func setCellSelected(_ isSelected: Bool) {
        contentView.layer.borderColor = isSelected ? UIColor.systemGray3.cgColor : nil
        contentView.layer.borderWidth = isSelected ? 3 : 0
    }
}
