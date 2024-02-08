import Foundation
import Fakery

public struct ArticleCategory: Identifiable, Decodable, Hashable {
    public let id: Int
    public let title: String
    public let order: Int
    
    public static func placeholder() -> ArticleCategory {
        let faker = Faker()
        return ArticleCategory(
            id: Int.random(in: -999 ... 0),
            title: faker.lorem.word(),
            order: Int.random(in: 0...100)
        )
    }
}
