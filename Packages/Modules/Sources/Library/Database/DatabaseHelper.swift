// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import GRDB

public enum DatabaseHelper {
    
    /// Checks if a table with the given name exists in the SQLite database.
    ///
    /// - Parameters:
    ///   - tableName: The name of the table to check for existence.
    ///   - databaseQueue: The `DatabaseQueue` instance that manages the SQLite database connection.
    ///
    /// - Returns:
    ///   - `true` if the table exists, `false` otherwise.
    ///
    /// - Throws:
    ///   This method will catch any errors and return `false` in case of an error.
    ///
    public static func tableExists(
        _ tableName: String,
        databaseQueue: DatabaseQueue
    ) -> Bool {
        do {
            return try databaseQueue.read { db in
                let result = try Row.fetchAll(db, sql: "SELECT name FROM sqlite_master WHERE type='table' AND name = ?", arguments: [tableName])
                return result.isEmpty == false
            }
        } catch {
            return false
        }
    }
    
}
