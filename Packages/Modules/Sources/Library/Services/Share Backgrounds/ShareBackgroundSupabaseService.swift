import Supabase

final class ShareBackgroundSupabaseService: ShareBackgroundService {
    private let supabaseClient: SupabaseClient

    init(supabaseClient: SupabaseClient) throws {
        self.supabaseClient = supabaseClient
    }
    
    override func loadBackgrounds() async throws -> [ZikrShareBackgroundItem] {
        let backgrounds: [ShareBackground] = try await supabaseClient
            .from("share_backgrounds")
            .select()
            .execute()
            .value
        return backgrounds.map { item in
                ZikrShareBackgroundItem(
                    id: item.id.description,
                    background: .remoteImage(item),
                    type: .image
                )
        }
    }
}
