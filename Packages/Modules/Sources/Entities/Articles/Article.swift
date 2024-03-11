import Foundation
import Fakery

public struct Article: Identifiable, Hashable, Codable {
    public let id: Int
    public let language: Language
    public let title: String
    public let tags: [String]?
    public let category: ArticleCategory
    public let text: String
    public let textFormat: ArticleDTO.TextFormat
    public let coverImage: CoverImage?
    public let coverImageAltText: String?
    public var views: Int?
    public var shares: Int?
    public let createdAt: Date
    
    public struct CoverImage: Hashable, Codable {
        public let imageType: ImageType
        public let imageFormat: ArticleDTO.CoverImageFormat
        
        public init(imageType: ImageType, imageFormat: ArticleDTO.CoverImageFormat) {
            self.imageType = imageType
            self.imageFormat = imageFormat
        }
    }
    
    public enum ImageType: Hashable, Codable {
        case link(URL), resource(String)
    }
    
}

extension Article {
    public init(
        _ article: ArticleDTO,
        category: ArticleCategory,
        viewsCount: Int?,
        sharesCount: Int?
    ) {
        id = article.id
        language = article.language
        title = article.title
        tags = article.tags?.compactMap { tag in
            "#" + tag
        }
        createdAt = article.createdAt
        text = article.text
        textFormat = article.textFormat
        self.views = viewsCount
        self.shares = sharesCount
        self.category = category
        coverImageAltText = article.coverImageAltText
        
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
        createdAt: Date = Date(),
        textFormat: ArticleDTO.TextFormat = .plain,
        coverImage: CoverImage? = nil,
        coverImageAltText: String? = nil
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
            coverImageAltText: coverImageAltText ?? faker.lorem.paragraphs(),
            views: Int.random(in: 0...1000),
            shares: Int.random(in: 0...1000),
            createdAt: createdAt
        )
    }
}
