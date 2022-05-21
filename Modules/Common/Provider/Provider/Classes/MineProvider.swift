//
//  MineProvider.swift
//  Provider
//
//  Created by 方昱恒 on 2022/5/18.
//


public protocol MineProvider: PGProvider {
    func getMineViewController() -> UIViewController?
}
