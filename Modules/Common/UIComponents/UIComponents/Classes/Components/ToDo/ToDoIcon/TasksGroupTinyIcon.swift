//
//  TasksGroupTinyIcon.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/3/1.
//

import UIKit
import SnapKit

public class TasksGroupTinyIcon: UIView {
    
    public var image: UIImage {
        didSet {
            imageView.image = image
        }
    }
    
    public var color: TasksGroupIconColor {
        didSet {
            self.backgroundColor = TasksGroupIconColorImpl.plainColor(with: color)
        }
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        self.image.withTintColor(.white, renderingMode: .alwaysTemplate)
        imageView.image = self.image
        imageView.tintColor = .white
        
        return imageView
    }()
    
    public init(image: UIImage, color: TasksGroupIconColor) {
        self.image = image
        self.color = color
        super.init(frame: .zero)
        self.backgroundColor = TasksGroupIconColorImpl.plainColor(with: color)
        self.layer.cornerRadius = 16
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(5)
            make.trailing.bottom.equalToSuperview().offset(-5)
            make.height.width.equalTo(22)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
