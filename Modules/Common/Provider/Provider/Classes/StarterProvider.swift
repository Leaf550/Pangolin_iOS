//
//  StarterProvider.swift
//  Provider
//
//  Created by 方昱恒 on 2022/2/27.
//

import UIKit

public protocol StarterProvider: PGProvider {
    func getTabBarController() -> UITabBarController
}
