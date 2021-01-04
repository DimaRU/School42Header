/////
////  UserDefaultsWrapper.swift
///   Copyright © 2020 Dmitriy Borovikov. All rights reserved.
//


import Foundation

fileprivate let appGroup = "9BEQ8V4XH9.in.iohack.school42header"
@propertyWrapper
struct UserPreferenceWithDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults(suiteName: appGroup)?.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults(suiteName: appGroup)?.set(newValue, forKey: key)
        }
    }
}

@propertyWrapper
struct UserPreference<T> {
    let key: String

    init(_ key: String) {
        self.key = key
    }

    var wrappedValue: T? {
        get {
            return UserDefaults(suiteName: appGroup)?.object(forKey: key) as? T
        }
        set {
            UserDefaults(suiteName: appGroup)?.set(newValue, forKey: key)
        }
    }
}
