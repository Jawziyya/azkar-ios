//
//  UserDefaultsWrapper.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 02.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation
import Combine

@propertyWrapper
public struct Preference<Value: Codable> {
    public let key: String
    public let defaultValue: Value
    public let defaults: UserDefaults

    private let notificationName: Notification.Name

    public init(_ key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = userDefaults
        notificationName = .init(key)
    }

    public var wrappedValue: Value {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(Value.self, from: data)
            return value ?? defaultValue
        } set {
            // Convert newValue to data
            let data = try? JSONEncoder().encode(newValue)

            // Set value to UserDefaults
            UserDefaults.standard.set(data, forKey: key)
            NotificationCenter.default.post(name: notificationName, object: newValue)
        }
    }

    public var projectedValue: Preference<Value> { self }

    public func publisher() -> AnyPublisher<Value, Never> {
        return NotificationCenter.default.publisher(for: notificationName)
            .map { _ in self.wrappedValue }
            .prepend(wrappedValue)
            .eraseToAnyPublisher()
    }

}
