//
//  PGModuleManager.swift
//  PGFoundation
//
//  Created by 方昱恒 on 2022/2/26.
//

public class PGModuleManager {
    
    public static let shared = PGModuleManager()
    
    private var moduleNames: [String] = [
        "Starter.StarterModule",
        "Persistence.PersistenceModule",
        "Account.AccountModule",
        "ToDo.ToDoModule",
        "BBS.BBSModule",
    ]
    
    private var modules = [PGModule]()
    
    public func loadModules() {
        for moduleName in moduleNames {
            guard let moduleType = NSClassFromString(moduleName) as? PGModule.Type else {
                fatalError("\(moduleName)模块不存在！")
                continue
            }
            let module = moduleType.shared
            modules.append(module)
        }
    }
    
    public func runModules() {
        for module in modules {
            module.runModule()
        }
    }
    
    public func notifyApplicationWillFinishLaunching() {
        for module in modules {
            module.applicationWillFinishLaunching()
        }
    }
    
    public func notifyApplicationDidFinishLaunching() {
        for module in modules {
            module.applicationDidFinishLaunching()
        }
    }
    
    public func notifyApplicationDidSetUpViews() {
        for module in modules {
            module.applicationDidSetUpViews()
        }
    }
    
}
