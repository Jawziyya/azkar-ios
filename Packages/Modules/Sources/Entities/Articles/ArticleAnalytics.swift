import Foundation

public struct ArticleAnalytics: Decodable {
    public let viewsCount: Int
    public let sharesCount: Int
    
    public init(views: Int, shares: Int) {
        self.viewsCount = views
        self.sharesCount = shares
    }
}
