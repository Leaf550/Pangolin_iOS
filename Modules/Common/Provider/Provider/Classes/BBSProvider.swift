//
//  BBSProvider.swift
//  Provider
//
//  Created by 方昱恒 on 2022/3/31.
//

import Foundation

public protocol BBSProvider: PGProvider {
    func getBBSViewController() -> UIViewController?
}
