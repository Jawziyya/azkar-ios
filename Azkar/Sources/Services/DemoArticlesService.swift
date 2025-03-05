import Foundation
import Entities
import AzkarServices

final class DemoArticlesService: ArticlesServiceType {
    func getArticle(_ id: Article.ID, updatedAfter: Date?) async throws -> Article? { nil }
    func getArticles(limit: Int) -> AsyncThrowingStream<[Article], Error> {
        return AsyncThrowingStream {
            return [.placeholder()]
        }
    }
    func sendAnalyticsEvent(_ type: AnalyticsRecord.ActionType, articleId: Article.ID) {}
    func updateAnalyticsNumbers(for articleId: Article.ID, views: Int, shares: Int) {}
    func observeAnalyticsNumbers(articleId: Article.ID) async -> AsyncStream<ArticleAnalytics> {
        return AsyncStream { _ in }
    }
}
