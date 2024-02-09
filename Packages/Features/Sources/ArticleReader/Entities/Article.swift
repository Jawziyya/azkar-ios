import Foundation
import Fakery
import Entities

public struct Article: Identifiable, Hashable {
    public let id: Int
    public let language: Language
    public let title: String
    public let tags: [String]?
    public let category: ArticleCategory
    public let text: String
    public let textFormat: ArticleDTO.TextFormat
    public let coverImage: CoverImage?
    public let views: Int
    
    public struct CoverImage: Hashable {
        let imageType: ImageType
        let imageFormat: ArticleDTO.CoverImageFormat
    }
    
    public enum ImageType: Hashable {
        case link(URL), resource(String)
    }
    
}

extension Article {
    public init(
        _ article: ArticleDTO,
        category: ArticleCategory,
        viewsCount: Int?
    ) {
        id = article.id
        language = article.language
        title = article.title
        tags = article.tags?.compactMap { tag in
            "#" + tag
        }
        text = article.text
        textFormat = article.textFormat
        self.views = viewsCount ?? 0
        self.category = category
        
        if let coverImageFormat = article.coverImageFormat {
            let imageType: ImageType
            if let link = article.imageLink, let url = URL(string: link) {
                imageType = .link(url)
            } else if let resourceName = article.imageResourceName {
                imageType = .resource(resourceName)
            } else {
                coverImage = nil
                return
            }
            
            coverImage = .init(imageType: imageType, imageFormat: coverImageFormat)
        } else {
            coverImage = nil
        }
    }
}

// MARK: - Placeholder objects
extension Article {
    
    public static func placeholder(
        id: Int = Int.random(in: -999 ... -1),
        language: Language = .russian,
        title: String? = nil,
        tags: [String]? = nil,
        category: ArticleCategory = .placeholder(),
        text: String? = nil,
        textFormat: ArticleDTO.TextFormat = .plain,
        coverImage: CoverImage? = nil
    ) -> Article {
        let faker = Faker()
        return Article(
            id: id,
            language: language,
            title: title ?? faker.lorem.words().capitalized,
            tags: tags ?? Array(repeating: {
                "#" + faker.lorem.word()
            }(), count: Int.random(in: 1...5)),
            category: category,
            text: text ?? faker.lorem.paragraphs(amount: 10)
                .components(separatedBy: "\n")
                .joined(separator: "\n\n"),
            textFormat: textFormat,
            coverImage: coverImage,
            views: Int.random(in: 0...1000)
        )
    }
}
