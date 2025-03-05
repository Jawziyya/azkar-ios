import Foundation
import Alamofire

let BACKGROUNDS_BASE_URL = URL(string: "https://azkar.ams3.digitaloceanspaces.com/media/share-backgrounds")!

enum ShareBackgroundType: String, Codable, Hashable {
    case color
    case pattern
    case image
}

struct ShareBackground: Codable, Hashable {
    let type: ShareBackgroundType
    let name: String
    
    var originalURL: URL {
        BACKGROUNDS_BASE_URL.appendingPathComponent("original").appendingPathComponent(type.rawValue).appendingPathComponent(name)
    }
    
    var previewURL: URL {
        BACKGROUNDS_BASE_URL.appendingPathComponent("preview").appendingPathComponent(type.rawValue).appendingPathComponent(name)
    }
}

struct ShareBackgroundsResponse: Codable {
    let backgrounds: [ShareBackground]
}

final class ShareBackgroundService: ObservableObject {
    private let cache: URLCache
    private let session: Session
    
    init() {
        // Configure a cache with 20MB memory capacity and 100MB disk capacity
        self.cache = URLCache(
            memoryCapacity: 20 * 1024 * 1024,     // 20MB
            diskCapacity: 100 * 1024 * 1024,      // 100MB
            diskPath: "share_backgrounds_cache"
        )
        
        // Create a session configuration with the cache
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        // Create Alamofire session with this configuration
        self.session = Session(configuration: configuration)
    }
    
    func loadBackgrounds() async throws -> [ZikrShareBackgroundItem] {
        let jsonURL = BACKGROUNDS_BASE_URL.appendingPathComponent("backgrounds.json")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        var request = try URLRequest(url: jsonURL, method: .get, headers: ["Cache-Control": "max-age=3600"])
        // Set the cachePolicy to return cached data if available and not expired
        request.cachePolicy = .returnCacheDataElseLoad
        
        let backgroundImages = try await session.request(request)
            .validate()
            .asyncDecodable(of: ShareBackgroundsResponse.self, decoder: decoder)
            .backgrounds
        
        return backgroundImages.map {
            ZikrShareBackgroundItem(
                id: $0.name,
                backgroundType: .remoteImage($0),
                isProItem: true
            )
        }
    }
}
