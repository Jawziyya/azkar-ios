import Foundation
import Fakery

public struct Article: Identifiable, Hashable, Codable, Equatable {
    public let id: Int
    public let categoryId: ArticleCategory.ID?
    public let language: Language
    
    public let tags: [String]?
    
    public let title: String
    public let text: String
    public let textFormat: TextFormat
    
    public let imageLink: String?
    public let imageResourceName: String?
    public let coverImageFormat: CoverImageFormat?
    public let coverImageAltText: String?
    
    public var views: Int
    public var shares: Int
    
    public let createdAt: Date
    public let updatedAt: Date
    
    // Computed property for coverImage from separate fields
    public var coverImage: CoverImage? {
        guard let format = coverImageFormat else { return nil }
        if let link = imageLink, let url = URL(string: link) {
            return CoverImage(imageType: .link(url), imageFormat: format)
        }
        if let resourceName = imageResourceName {
            return CoverImage(imageType: .resource(resourceName), imageFormat: format)
        }
        return nil
    }
    
    public struct CoverImage: Hashable {
        public let imageType: ImageType
        public let imageFormat: CoverImageFormat
        
        public init(imageType: ImageType, imageFormat: CoverImageFormat) {
            self.imageType = imageType
            self.imageFormat = imageFormat
        }
    }
    
    public enum ImageType: Hashable {
        case link(URL), resource(String)
    }
    
    public enum TextFormat: String, Codable, Hashable {
        case plain, markdown
    }
    
    public enum CoverImageFormat: String, Codable, Hashable {
        case titleBackground = "title_background"
        case standaloneTop = "standalone_top"
        case standaloneUnderTitle = "standalone_under_title"
    }
}

// MARK: - Placeholder objects
extension Article {
    
    public static func placeholder(
        id: Int = Int.random(in: -999 ... -1),
        language: Language = .russian,
        title: String? = nil,
        tags: [String]? = nil,
        text: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        textFormat: TextFormat = .plain,
        imageLink: String? = nil,
        imageResourceName: String? = nil,
        coverImageFormat: CoverImageFormat? = nil,
        coverImageAltText: String? = nil
    ) -> Article {
        let faker = Faker()
        return Article(
            id: id,
            categoryId: nil,
            language: language,
            tags: tags ?? Array(repeating: {
                "#" + faker.lorem.word()
            }(), count: Int.random(in: 1...5)),
            title: title ?? faker.lorem.words().capitalized,
            text: text ?? faker.lorem.paragraphs(amount: 10)
                .components(separatedBy: "\n")
                .joined(separator: "\n\n"),
            textFormat: textFormat,
            imageLink: imageLink,
            imageResourceName: imageResourceName,
            coverImageFormat: coverImageFormat,
            coverImageAltText: coverImageAltText ?? faker.lorem.paragraphs(),
            views: Int.random(in: 0...1000),
            shares: Int.random(in: 0...1000),
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

