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
    
    func loadBackgrounds() async throws -> [ZikrShareBackgroundItem] {
        let jsonURL = BACKGROUNDS_BASE_URL.appendingPathComponent("backgrounds.json")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let backgroundImages = try await AF.request(
            jsonURL,
            method: HTTPMethod.get,
            headers: ["Cache-Control": "max-age=3600"]
        )
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
