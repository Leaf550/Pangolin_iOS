//
//  PGModule.swift
//  PGFoundation
//
//  Created by 方昱恒 on 2022/2/26.
//

public enum PGModuleRunningTime {
    case willFinishLaunching    // App 即将启动完成
    case didFinishLaunching     // App 已经启动完成
    case viewsDidSetup          // App 视图初始化完成
}

public protocol PGModule {
    
    static var shared: PGModule { get }
    
    // 做一些各业务模块的初始化工作
    func runModule()
    func applicationWillFinishLaunching()
    func applicationDidFinishLaunching()
    func applicationDidSetUpViews()
    
}

extension PGModule {
    
    public func applicationWillFinishLaunching() { }
    
    public func applicationDidFinishLaunching() { }
    
    public func applicationDidSetUpViews() { }
    
}
