//
//  ToDoLargeIcon.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/3/1.
//

import UIKit
import SnapKit

public class ToDoLargeIcon: UIView {

    private var image: UIImage
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        self.image.withTintColor(.white, renderingMode: .alwaysTemplate)
        imageView.image = self.image
        
        return imageView
    }()
    
    public init(image: UIImage, backgroundColor: ToDoIconColor) {
        self.image = image
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 48
        
        let gradient = CAGradientLayer()
        gradient.colors = ToDoIconColorImpl.gradient(with: backgroundColor)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        gradient.cornerRadius = 48
        self.layer.addSublayer(gradient)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.bottom.trailing.equalToSuperview().offset(-20)
            make.height.width.equalTo(56)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
