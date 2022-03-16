//
//  KV.swift
//  KV
//
//  Created by 方昱恒 on 2022/3/15.
//

import PGFoundation
import MMKV
import Foundation

class KVModule: PGModule {
    
    public static var shared: PGModule = KVModule()
    
    func runModule() { }
    
    func applicationDidFinishLaunching() {
        MMKV.initialize(rootDir: nil)
    }
    
}

public enum KVStoreField {
    case global
    case account
}

public class KV {
    
    private let mmkv = MMKV.default()
    private static var storedInAccountField = [String]()
    private var field: KVStoreField = .global
    private var key: String?
    
    public init() {}
    
    public init(field: KVStoreField) {
        self.field = field
    }
    
    public func clearAll() {
        mmkv?.clearAll()
    }
    
    // MARK: - Set
    public func set(_ value: Bool, forKey key: String) -> Bool {
        if field == .account {
            KV.storedInAccountField.append(key)
        }
        return ((mmkv?.set(value, forKey: key)) != nil)
    }
    
    public func set(_ value: UInt64, forKey key: String) -> Bool {
        if field == .account {
            KV.storedInAccountField.append(key)
        }
        return ((mmkv?.set(value, forKey: key)) != nil)
    }
    
    public func set(_ value: UInt32, forKey key: String) -> Bool {
        if field == .account {
            KV.storedInAccountField.append(key)
        }
        return ((mmkv?.set(value, forKey: key)) != nil)
    }
    
    public func set(_ value: Int64, forKey key: String) -> Bool {
        if field == .account {
            KV.storedInAccountField.append(key)
        }
        return ((mmkv?.set(value, forKey: key)) != nil)
    }
    
    public func set(_ value: Int32, forKey key: String) -> Bool {
        if field == .account {
            KV.storedInAccountField.append(key)
        }
        return ((mmkv?.set(value, forKey: key)) != nil)
    }
    
    public func set(_ value: Float, forKey key: String) -> Bool {
        if field == .account {
            KV.storedInAccountField.append(key)
        }
        return ((mmkv?.set(value, forKey: key)) != nil)
    }
    
    
    public func set(_ value: Double, forKey key: String) -> Bool {
        if field == .account {
            KV.storedInAccountField.append(key)
        }
        return ((mmkv?.set(value, forKey: key)) != nil)
    }
    
    public func set(_ value: String, forKey key: String) -> Bool {
        if field == .account {
            KV.storedInAccountField.append(key)
        }
        return ((mmkv?.set(value, forKey: key)) != nil)
    }
    
    public func set(_ value: Date, forKey key: String) -> Bool {
        if field == .account {
            KV.storedInAccountField.append(key)
        }
        return ((mmkv?.set(value, forKey: key)) != nil)
    }
    
    public func set(_ value: Data, forKey key: String) -> Bool {
        if field == .account {
            KV.storedInAccountField.append(key)
        }
        return ((mmkv?.set(value, forKey: key)) != nil)
    }
    
    public func set<T: Codable>(_ value: T, forKey key: String) -> Bool {
        if field == .account {
            KV.storedInAccountField.append(key)
        }
        guard let data = try? JSONEncoder().encode(value) else { return false }
        return set(data, forKey: key)
    }
    
    // MARK: - Get
    public func bool(forKey key: String, defaultValue: Bool? = nil) -> Bool? {
        mmkv?.bool(forKey: key) ?? defaultValue
    }
    
    public func uint64(forKey key: String, defaultValue: UInt64? = nil) -> UInt64? {
        mmkv?.uint64(forKey: key) ?? defaultValue
    }
    
    public func uint32(forKey key: String, defaultValue: UInt32? = nil) -> UInt32? {
        mmkv?.uint32(forKey: key) ?? defaultValue
    }
    
    public func int64(forKey key: String, defaultValue: Int64? = nil) -> Int64? {
        mmkv?.int64(forKey: key) ?? defaultValue
    }
    
    public func int32(forKey key: String, defaultValue: Int32? = nil) -> Int32? {
        mmkv?.int32(forKey: key) ?? defaultValue
    }
    
    public func float(forKey key: String, defaultValue: Float? = nil) -> Float? {
        mmkv?.float(forKey: key) ?? defaultValue
    }
    
    public func double(forKey key: String, defaultValue: Double? = nil) -> Double? {
        mmkv?.double(forKey: key) ?? defaultValue
    }
    
    public func string(forKey key: String, defaultValue: String? = nil) -> String? {
        mmkv?.string(forKey: key) ?? defaultValue
    }
    
    public func date(forKey key: String, defaultValue: Date? = nil) -> Date? {
        mmkv?.date(forKey: key) ?? defaultValue
    }
    
    public func data(forKey key: String, defaultValue: Data? = nil) -> Data? {
        mmkv?.data(forKey: key) ?? defaultValue
    }
    
    public func object<Item: Codable>(_ type: Item.Type, forKey key: String) -> Item? {
        guard let data = mmkv?.data(forKey: key) else { return nil }
        guard let object = try? JSONDecoder().decode(type, from: data) else { return nil }
        return object
    }
    
    // MARK: - Remove
    public func removeValue(forKey key: String) {
        mmkv?.removeValue(forKey: key)
    }
    
}
