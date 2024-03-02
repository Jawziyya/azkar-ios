import Foundation

public struct ArticleDTO: Identifiable, Codable, Hashable {
    public enum TextFormat: String, Hashable, Codable {
        case plain, markdown
    }
    
    public enum CoverImageFormat: String, Hashable, Codable {
        case titleBackground = "title_background"
        case standaloneTop = "standalone_top"
        case standaloneUnderTitle = "standalone_under_title"
    }
    
    public let id: Int
    public let language: Language
    public let title: String
    public let tags: [String]?
    public let category: ArticleCategory.ID?
    public let text: String
    public let textFormat: TextFormat
    public let coverImageFormat: CoverImageFormat?
    public let coverImageAltText: String?
    public let imageLink: String?
    public let imageResourceName: String?
    public let views: Int?
    public let createdAt: Date
}
