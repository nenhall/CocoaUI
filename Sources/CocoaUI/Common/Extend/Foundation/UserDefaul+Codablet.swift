//
//  File.swift
//  
//
//  Created by nenhall on 3/28/25.
//

import Foundation
import SwiftUI

public extension UserDefaults {
    func codable<T: Codable>(forKey key: String, defaultValue: T) -> T {
        guard let data = data(forKey: key),
              let value = try? JSONDecoder().decode(T.self, from: data)
        else {
            return defaultValue
        }
        return value
    }

    func setCodable<T: Codable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else {
            return
        }
        set(data, forKey: key)
    }
}

//@propertyWrapper
//public struct AppStorageObject<T: Codable> {
//    public let key: String
//    public let defaultValue: T
//
//    public var wrappedValue: T {
//        get {
//            return UserDefaults.standard.codable(forKey: key, defaultValue: defaultValue)
//        }
//        set {
//            UserDefaults.standard.setCodable(newValue, forKey: key)
//            UserDefaults.standard.synchronize()
//        }
//    }
//    
//    
//
//    public init(key: String, defaultValue: T) {
//        self.key = key
//        self.defaultValue = defaultValue
//    }
//}
@propertyWrapper
public class AppStorageObject<T: Codable> {
    private let key: String
    private let defaultValue: T
    
    public var wrappedValue: T {
        get { UserDefaults.standard.codable(forKey: key, defaultValue: defaultValue) }
        set { UserDefaults.standard.setCodable(newValue, forKey: key) }
    }
    
    // 返回 Binding<T>
    public var projectedValue: Binding<T> {
        Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0 }
        )
    }
    
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}
