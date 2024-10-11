import Entities
import Library

final class DemoArticlesService: ArticlesServiceType {
    func getArticle(_ id: Article.ID) async throws -> Article? { nil }
    func getArticles(limit: Int) -> AsyncThrowingStream<[Article], Error> {
        return AsyncThrowingStream {
            return [.placeholder()]
        }
    }
    func sendAnalyticsEvent(_ type: AnalyticsRecord.ActionType, articleId: Article.ID) async {}
    func observeAnalyticsNumbers(articleId: Article.ID) async -> AsyncStream<ArticleAnalytics> {
        return AsyncStream { _ in }
    }
}
