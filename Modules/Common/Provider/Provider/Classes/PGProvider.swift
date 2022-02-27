//
//  CYProvider.swift
//  Provider
//
//  Created by 方昱恒 on 2022/2/27.
//

public protocol PGProvider { }

public class PGProviderManager {
    
    public static var shared = PGProviderManager()
    
    private var providers = [String : PGProvider]()
    
    public func provider<P>(forProtocol: () -> P.Type) -> P? {
        return providers["\(forProtocol())"] as? P
    }
    
    public func registerProvider<P>(_ providerKey: () -> P.Type, _ provider: P) {
        providers["\(providerKey())"] = provider as? PGProvider
    }
    
    public func deregisterProvider<P>(_ providerKey: () -> P.Type) {
        providers.removeValue(forKey: "\(providerKey())")
    }
    
}
