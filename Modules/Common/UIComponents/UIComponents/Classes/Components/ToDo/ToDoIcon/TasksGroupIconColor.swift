//
//  TasksGroupIconColor.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/3/2.
//

import UIKit

public enum TasksGroupIconColor: Int {
    case red        = 0
    case orange     = 1
    case yellow     = 2
    case green      = 3
//    case cyan       = 4
    case blue       = 4
    case purple     = 5
    case gray       = 6
}

public class TasksGroupIconColorImpl {
    
    public static func plainColor(with enumerate: TasksGroupIconColor) -> UIColor {
        switch enumerate {
            case .red:
                return UIColor(hexString: "#ff3a31")
            case .orange:
                return UIColor(hexString: "#ff9503")
            case .yellow:
                return UIColor(hexString: "#ffcb00")
            case .green:
                return UIColor(hexString: "#1ac759")
//            case .cyan:
//                return UIColor(hexString: "#67a8eb")
            case .blue:
                return UIColor(hexString: "#027aff")
            case .purple:
                return UIColor(hexString: "#5956d5")
            case .gray:
                return UIColor(hexString: "#59626a")
        }
    }
    
    public static func gradient(with enumerate: TasksGroupIconColor) -> [CGColor] {
        switch enumerate {
            case .red:
                return [UIColor(hexString: "#ff6459").cgColor, UIColor(hexString: "#ff3c32").cgColor]
            case .orange:
                return [UIColor(hexString: "#ffbe2d").cgColor, UIColor(hexString: "#ff9601").cgColor]
            case .yellow:
                return [UIColor(hexString: "#fff52f").cgColor, UIColor(hexString: "#ffcc01").cgColor]
            case .green:
                return [UIColor(hexString: "#41ee81").cgColor, UIColor(hexString: "#1dc85a").cgColor]
//            case .cyan:
//                return [UIColor(hexString: "#8ed0ff").cgColor, UIColor(hexString: "#68a9ed").cgColor]
            case .blue:
                return [UIColor(hexString: "#28a1ff").cgColor, UIColor(hexString: "#077cff").cgColor]
            case .purple:
                return [UIColor(hexString: "#7f7dfd").cgColor, UIColor(hexString: "#5a57d6").cgColor]
            case .gray:
                return [UIColor(hexString: "#3a2d45").cgColor, UIColor(hexString: "#5a5d65").cgColor]
        }
    }
    
}
