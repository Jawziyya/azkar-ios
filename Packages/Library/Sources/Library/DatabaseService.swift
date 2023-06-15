// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Entities
import GRDB
import Foundation

extension Hadith: FetchableRecord, PersistableRecord {
    public static let databaseTableName = "ahadith"
}

extension Zikr: FetchableRecord, PersistableRecord {
    public static let databaseTableName = "azkar"
}

extension Fadl: FetchableRecord, PersistableRecord {
    public static let databaseTableName = "fadail"
}

extension AudioTiming: FetchableRecord, PersistableRecord {
    public static let databaseTableName = "audio_timings"
}

public enum DatabaseServiceError: Error {
    case databaseFileAccesingError
}

public final class DatabaseService {

    public static let shared = DatabaseService()

    private init() { }

    private func getDatabasePath() throws -> String {
        guard let path = Bundle.main.path(forResource: "azkar", ofType: "db") else {
            throw DatabaseServiceError.databaseFileAccesingError
        }
        return path
    }

    private func getDatabaseQueue() throws -> DatabaseQueue {
        var config = Configuration()
        config.readonly = true
        return try DatabaseQueue(path: getDatabasePath(), configuration: config)
    }

    public func getAhadith() throws -> [Hadith] {
        return try getDatabaseQueue().read { db in
            try Hadith.fetchAll(db)
        }
    }

    public func getHadith(_ id: Int) throws -> Hadith? {
        return try getDatabaseQueue().read { db in
            try Hadith.fetchOne(db, id: id)
        }
    }

    public func getFadailCount() throws -> Int {
        return try getDatabaseQueue().read { db in
            try Fadl.fetchCount(db)
        }
    }

    public func getFadl(_ id: Int) throws -> Fadl? {
        return try getDatabaseQueue().read { db in
            try Fadl.fetchOne(db, id: id)
        }
    }

    public func getRandomFadl() throws -> Fadl? {
        let count = try getFadailCount()
        let id = Int.random(in: 1...count)
        return try getFadl(id)
    }

    public func getFadail() throws -> [Fadl] {
        return try getDatabaseQueue().read { db in
            try Fadl.fetchAll(db)
        }
    }

}

// MARK: - Adhkar
public extension DatabaseService {

    func getZikr(_ id: Int) throws -> Zikr? {
        return try getDatabaseQueue().read { db in
            try Zikr.fetchOne(db, id: id)
        }
    }

    func getAllAdhkar() throws -> [Zikr] {
        return try getDatabaseQueue().read { db in
            try Zikr.order(sql: "row_in_category").fetchAll(db)
        }
    }

    func getAdhkar(_ category: ZikrCategory) throws -> [Zikr] {
        return try getDatabaseQueue().read { db in
            try Zikr
                .order(sql: "row_in_category")
                .filter(sql: "category = ?", arguments: [category.rawValue])
                .fetchAll(db)
        }
    }

    func getAdhkarCount(_ category: ZikrCategory) throws -> Int {
        return try getDatabaseQueue().read { db in
            try Zikr
                .filter(sql: "category = ?", arguments: [category.rawValue])
                .fetchCount(db)
        }
    }

    func getAudioTimings(audioId: Int) throws -> [AudioTiming] {
        return try getDatabaseQueue().read { db in
            try AudioTiming
                .filter(sql: "audio_id = ?", arguments: [audioId])
                .fetchAll(db)
        }
    }

}
