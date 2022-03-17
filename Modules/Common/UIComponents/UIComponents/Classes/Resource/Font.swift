//
//  Font.swift
//  PGFoundation
//
//  Created by 方昱恒 on 2022/2/28.
//

import UIKit

public enum FontSize: CGFloat {
    case largeTitle     = 34
    case title1         = 28
    case title2         = 22
    case title3         = 20
    case body           = 17
    case caption0       = 15
    case caption1       = 12
    case caption2       = 11
}

public enum FontWeight: CGFloat {
    case light          = 300
    case regular        = 400
    case medium         = 500
    case semibold       = 600
    case bold           = 700
}

public extension UIFont {
    static func textFont(for size: FontSize, weight: UIFont.Weight) -> UIFont {
        .systemFont(ofSize: size.rawValue, weight: weight)
    }
}
