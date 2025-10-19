import Foundation
import Supabase
import Entities

final class ShareBackgroundSupabaseRepository {
    
    private let supabaseClient: SupabaseClient
    
    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    func getBackgrounds(newerThan date: Date? = nil) async throws -> [ShareBackground] {
        var query = supabaseClient
            .from("share_backgrounds")
            .select()
        
        if let date = date {
            query = query.gt("created_at", value: date.addingTimeInterval(1))
        }
        
        let backgrounds: [ShareBackground] = try await query
            .execute()
            .value
        return backgrounds
    }
    
}
