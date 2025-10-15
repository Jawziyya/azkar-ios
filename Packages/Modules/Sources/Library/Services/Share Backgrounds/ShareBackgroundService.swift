import Foundation
import Supabase

public enum ShareBackgroundServiceProvider {
    public static func createShareBackgroundService() -> ShareBackgroundService {
        do {
            return try ShareBackgroundSupabaseService(supabaseClient: getSupabaseClient())
        } catch {
            return MockShareBackgroundsService()
        }
    }
}

public class ShareBackgroundService: ObservableObject {
    public func loadBackgrounds() async throws -> [ZikrShareBackgroundItem] {
        return []
    }
}
