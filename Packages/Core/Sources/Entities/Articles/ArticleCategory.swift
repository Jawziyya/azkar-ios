import Foundation
import Fakery

public struct ArticleCategory: Identifiable, Codable, Hashable {
    public static var language = Language.getSystemLanguage()
    
    public let id: Int
    public let titleEn: String
    public let titleAr: String
    public let titleRu: String
    public let order: Int
    
    public var title: String {
        let lang = ArticleCategory.language
        if lang == .arabic || lang.fallbackLanguage == .arabic {
            return titleAr
        } else if lang == .russian || lang.fallbackLanguage == .russian {
            return titleRu
        } else {
            return titleEn
        }
    }
        
    public static func placeholder() -> ArticleCategory {
        let faker = Faker()
        return ArticleCategory(
            id: Int.random(in: -999 ... 0),
            titleEn: faker.lorem.word(),
            titleAr: faker.lorem.word(),
            titleRu: faker.lorem.word(),
            order: Int.random(in: 0...100)
        )
    }
}
