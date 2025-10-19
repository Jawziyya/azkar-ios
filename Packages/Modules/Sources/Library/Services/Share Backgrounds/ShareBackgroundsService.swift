import Supabase
import DatabaseInteractors
import Entities

public final class ShareBackgroundsService: ShareBackgroundsServiceType {

    private let supabaseClient: SupabaseClient
    private let localRepository: ShareBackgroundsSQLiteRepository
    private let remoteRepository: ShareBackgroundSupabaseRepository

    init(supabaseClient: SupabaseClient, databaseFilePath: String) throws {
        self.supabaseClient = supabaseClient
        self.localRepository = try ShareBackgroundsSQLiteRepository(databaseFilePath: databaseFilePath)
        self.remoteRepository = ShareBackgroundSupabaseRepository(supabaseClient: supabaseClient)
    }
    
    public override func loadBackgrounds() -> AsyncThrowingStream<[ZikrShareBackgroundItem], Error> {
        let remoteRepository = self.remoteRepository
        let localRepository = self.localRepository
        
        return AsyncThrowingStream { continuation in
            Task {
                var cachedBackgrounds: [ShareBackground] = []
                do {
                    let backgrounds = try await localRepository.getBackgrounds()
                    cachedBackgrounds = backgrounds
                    if cachedBackgrounds.isEmpty == false {
                        continuation.yield(cachedBackgrounds.map { item in
                            ZikrShareBackgroundItem(
                                id: item.id.description,
                                background: .remoteImage(item),
                                type: item.type
                            )
                        })
                    }
                } catch {
                    print("Can't retrieve backgrounds from cache")
                }
                
                do {
                    let remoteBackgrounds = try await remoteRepository.getBackgrounds(
                        newerThan: cachedBackgrounds.max(by: { $0.createdAt < $1.createdAt })?.createdAt
                    )
                    try await localRepository.saveBackgrounds(remoteBackgrounds)
                    
                    let updatedCachedBackgrounds = try await localRepository.getBackgrounds()
                    let allBackgrounds = (cachedBackgrounds + remoteBackgrounds).unique(by: \.id)

                    if allBackgrounds != cachedBackgrounds {
                        continuation.yield(allBackgrounds.map { item in
                            ZikrShareBackgroundItem(
                                id: item.id.description,
                                background: .remoteImage(item),
                                type: item.type
                            )
                        })
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
