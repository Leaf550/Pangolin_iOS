//
//  PGModule.swift
//  PGFoundation
//
//  Created by 方昱恒 on 2022/2/26.
//

public protocol PGModule {
    
    static var shared: PGModule { get }
    
    // 做一些各业务模块的初始化工作
    func runModule()
    // 启动回调
    func applicationWillFinishLaunching()
    func applicationDidFinishLaunching()
    func applicationDidSetUpViews()
    
}

extension PGModule {
    
    public func applicationWillFinishLaunching() { }
    
    public func applicationDidFinishLaunching() { }
    
    public func applicationDidSetUpViews() { }
    
}
