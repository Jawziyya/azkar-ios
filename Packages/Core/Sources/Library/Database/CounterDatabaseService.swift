// Copyright © 2022 Al Jawziyya. All rights reserved.

import Foundation
import Entities
import GRDB

public final class CounterDatabaseService {
    
    private let databasePath: String
    private let getKey: () -> Int
    
    public init(
        databasePath: String,
        createDatabaseFileIfNeeded: Bool = true,
        getKey: @escaping () -> Int = {
            let startOfDay = Calendar.current.startOfDay(for: Date())
            return Int(startOfDay.timeIntervalSince1970)
        }
    ) {
        self.databasePath = databasePath
        self.getKey = getKey
        
        if createDatabaseFileIfNeeded {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: databasePath) == false {
                fileManager.createFile(atPath: databasePath, contents: Data())
            }
        }
        
        do {
            let queue = try getDatabaseQueue()
            let tableName = ZikrCounter.databaseTableName
            if DatabaseHelper.tableExists(tableName, databaseQueue: queue) == false {
                try queue.write { db in
                    try db.create(table: "counters") { t in
                        t.autoIncrementedPrimaryKey("id").notNull()
                        t.column("key", .integer).notNull()
                        t.column("zikr_id", .integer).notNull()
                    }
                }
            }
        } catch {
            // TODO: Handle errors.
        }
    }

    private func getDatabaseQueue() throws -> DatabaseQueue {
        return try DatabaseQueue(path: databasePath)
    }
        
    public func getRemainingRepeats(for zikr: Zikr) async -> Int {
        let key = getKey()
        do {
            return try await getDatabaseQueue().read { db in
                if let row = try Row.fetchOne(
                    db,
                    sql: "SELECT COUNT(*) as count FROM counters WHERE key = ? AND zikr_id = ?",
                    arguments: [key, zikr.id]
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
        let newRecord = ZikrCounter(key: getKey(), zikrId: zikr.id)
        try await getDatabaseQueue().write { db in
            try newRecord.insert(db)
        }
    }
    
}
