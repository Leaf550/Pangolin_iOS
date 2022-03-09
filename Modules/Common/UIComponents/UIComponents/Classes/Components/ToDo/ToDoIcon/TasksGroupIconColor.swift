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
                return UIColor(hexString: "#fb3e2d")
            case .orange:
                return UIColor(hexString: "#ff9514")
            case .yellow:
                return UIColor(hexString: "#f7cd15")
            case .green:
                return UIColor(hexString: "#00c660")
//            case .cyan:
//                return UIColor(hexString: "#67a8eb")
            case .blue:
                return UIColor(hexString: "#127aff")
            case .purple:
                return UIColor(hexString: "#5758ce")
            case .gray:
                return UIColor(hexString: "#5a5d65")
        }
    }
    
    public static func gradient(with enumerate: TasksGroupIconColor) -> [CGColor] {
        switch enumerate {
            case .red:
                return [UIColor(hexString: "#ff7060").cgColor, UIColor(hexString: "#eb4e3d").cgColor]
            case .orange:
                return [UIColor(hexString: "#ffbf41").cgColor, UIColor(hexString: "#f29b3f").cgColor]
            case .yellow:
                return [UIColor(hexString: "#fff45d").cgColor, UIColor(hexString: "#f8cd4b").cgColor]
            case .green:
                return [UIColor(hexString: "#7bea8c").cgColor, UIColor(hexString: "#61c46a").cgColor]
//            case .cyan:
//                return [UIColor(hexString: "#8ed0ff").cgColor, UIColor(hexString: "#68a9ed").cgColor]
            case .blue:
                return [UIColor(hexString: "#4fa0ff").cgColor, UIColor(hexString: "#317bf7").cgColor]
            case .purple:
                return [UIColor(hexString: "#7f80f6").cgColor, UIColor(hexString: "#585acf").cgColor]
            case .gray:
                return [UIColor(hexString: "#3a2d45").cgColor, UIColor(hexString: "#5a5d65").cgColor]
        }
    }
    
}
