import SwiftUI

struct SourceInfo: Decodable {
    
    let sections: [Section]
    
    struct Item: Decodable, Identifiable, Hashable {
        var id: String {
            return title
        }
        let title: String
        let link: String
        
        enum CodingKeys: String, CodingKey {
            case title, link
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let title = try container.decode(String.self, forKey: .title)
            self.title = NSLocalizedString(title, comment: "")
            link = try container.decode(String.self, forKey: .link)
        }
    }
    
    struct Section: Decodable, Identifiable, Hashable {
        let id: UUID
        let title: String
        let items: [Item]
        
        enum CodingKeys: String, CodingKey {
            case title, items
        }
        
        init(from decoder: any Decoder) throws {
            self.id = UUID()
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            let title = try container.decode(String.self, forKey: .title)
            self.title = NSLocalizedString(title, comment: "")
            self.items = try container.decode([SourceInfo.Item].self, forKey: CodingKeys.items)
        }
    }
}

public struct CreditsViewModel {
    let sections: [SourceInfo.Section]
    
    public init() {
        do {
            if let url = Bundle.main.url(forResource: "credits", withExtension: "json") {
                let data = try Data(contentsOf: url)
                let credits = try JSONDecoder().decode(SourceInfo.self, from: data)
                sections = credits.sections
            } else {
                sections = []
            }
        } catch {
            sections = []
        }
    }
}
