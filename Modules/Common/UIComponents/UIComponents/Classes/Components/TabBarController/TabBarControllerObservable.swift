//
//  TabBarControllerObservable.swift
//  UIComponents
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit

public protocol TabBarControllerObservable {
    
    func tabBarController(_ tabBarcontroller: TabBarController, didSelectAt index: Int)
    
}
