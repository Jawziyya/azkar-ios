// Copyright © 2022 Al Jawziyya. All rights reserved.

import Foundation
import Entities
import GRDB

public final class CounterDatabaseService {
    
    private let databasePath: String
    private let getKey: () -> Int
    
    public init(
        databasePath: String,
        getKey: @escaping () -> Int
    ) {
        self.databasePath = databasePath
        self.getKey = getKey
        
        do {
            let tableName = ZikrCounter.databaseTableName
            
            var migrator = DatabaseMigrator()
            migrator.registerMigration("Add category column") { db in
                do {
                    try db.alter(table: tableName) { t in
                        t.add(column: "category")
                    }
                    try db.execute(
                        sql: "UPDATE counters SET category = ?",
                        arguments: ["morning"]
                    )
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            let queue = try DatabaseQueue(path: databasePath)
            try migrator.migrate(queue)
            
            if DatabaseHelper.tableExists(tableName, databaseQueue: queue) == false {
                try queue.write { db in
                    try db.create(table: tableName) { t in
                        t.autoIncrementedPrimaryKey("id").notNull()
                        t.column("key", .integer).notNull()
                        t.column("zikr_id", .integer).notNull()
                        t.column("category", .text).notNull()
                    }
                }
            }
        } catch {
            // TODO: Handle errors.
            print(error)
        }
    }

    private func getDatabaseQueue() throws -> DatabaseQueue {
        return try DatabaseQueue(path: databasePath)
    }
        
    public func getRemainingRepeats(for zikr: Zikr) async -> Int {
        let key = getKey()
        do {
            return try await getDatabaseQueue().read { db in
                if let category = zikr.category, let row = try Row.fetchOne(
                    db,
                    sql: "SELECT COUNT(*) as count FROM counters WHERE key = ? AND zikr_id = ? AND category = ?",
                    arguments: [key, zikr.id, category.rawValue]
                ) {
                    let count: Int = row["count"]
                    return max(0, zikr.repeats - count)
                }
                return 0
            }
        } catch {
            return 0
        }
    }

    public func incrementCounter(for zikr: Zikr) async throws {
        let newRecord = ZikrCounter(key: getKey(), zikrId: zikr.id, category: zikr.category)
        try await getDatabaseQueue().write { db in
            try newRecord.insert(db)
        }
    }
    
}
