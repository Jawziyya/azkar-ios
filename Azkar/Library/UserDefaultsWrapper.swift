//
//  UserDefaultsWrapper.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 02.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Preference<T: Codable> {
    public let key: String
    public let defaultValue: T
    public let defaults: UserDefaults

    public init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = userDefaults
    }

    public var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)

            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
