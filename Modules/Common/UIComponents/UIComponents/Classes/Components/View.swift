//
//  View.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/3/2.
//

import UIKit

extension UIView {
    
    public func setRoundCorner(at positions: UIRectCorner, withRadius radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: positions, cornerRadii: CGSize(width: radius, height: radius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = path.cgPath

        self.layer.mask = shapeLayer
    }
    
}
