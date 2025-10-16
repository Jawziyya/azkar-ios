import Foundation
import Supabase
import DatabaseInteractors

public typealias MockShareBackgroundsService = ShareBackgroundsServiceType

public class ShareBackgroundsServiceType: ObservableObject {
    public init() {}

    public func loadBackgrounds() -> AsyncThrowingStream<[ZikrShareBackgroundItem], Error> {
        return AsyncThrowingStream { continuation in
            continuation.finish()
        }
    }
}

public enum ShareBackgroundsServiceProvider {
    public static func createShareBackgroundsService() -> ShareBackgroundsServiceType {
        do {
            let supabaseClient = try getSupabaseClient()
            let databasePath = try getDatabasePath()
            return try ShareBackgroundsService(supabaseClient: supabaseClient, databaseFilePath: databasePath)
        } catch {
            return MockShareBackgroundsService()
        }
    }
    
    private static func getDatabasePath() throws -> String {
        guard let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "ShareBackgroundServiceProvider", code: 1, userInfo: nil)
        }
        let appGroupFolder = path
        return appGroupFolder
            .appendingPathComponent("share_backgrounds.db")
            .absoluteString
    }
}
