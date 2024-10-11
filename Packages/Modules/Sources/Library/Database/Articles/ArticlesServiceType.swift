import Foundation
import Entities

enum ArticlesServiceError: Error {
    case localRepositoryUnavailable
    case failedToFetchArticles(Error)
    case failedToSaveArticles(Error)
}

public protocol ArticlesServiceType {
    func getArticles(limit: Int) -> AsyncThrowingStream<[Article], Error>
    func getArticle(_ id: Article.ID) async throws -> Article?
    func sendAnalyticsEvent(
        _ type: AnalyticsRecord.ActionType,
        articleId: Article.ID
    ) async
    func observeAnalyticsNumbers(articleId: Article.ID) async -> AsyncStream<ArticleAnalytics>
}
