//
//  TasksGroupLargeIcon.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/3/1.
//

import UIKit
import SnapKit

public class TasksGroupLargeIcon: UIView {
    
    public var color: TasksGroupIconColor {
        didSet {
            gradientLayer.colors = TasksGroupIconColorImpl.gradient(with: color)
            layer.shadowColor = TasksGroupIconColorImpl.gradient(with: color).first
        }
    }

    public var image: UIImage {
        didSet {
            imageView.image = image
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.image = image
        
        return imageView
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = TasksGroupIconColorImpl.gradient(with: color)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        gradient.cornerRadius = 48
        return gradient
    }()
    
    public init(image: UIImage, backgroundColor: TasksGroupIconColor) {
        self.image = image
        self.color = backgroundColor
        super.init(frame: .zero)
        
        layer.cornerRadius = 48
        layer.addSublayer(gradientLayer)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.bottom.trailing.equalToSuperview().offset(-20)
            make.height.width.equalTo(56)
        }
        
        layer.shadowOffset = .zero
        layer.shadowRadius = 30
        layer.shadowOpacity = 0.3
        layer.shadowColor = TasksGroupIconColorImpl.gradient(with: color).first
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
