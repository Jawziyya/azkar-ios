import Foundation
import Entities

public protocol ArticlesRepository {
    func getArticles(limit: Int, newerThan: Date?) async throws -> [Article]
    func saveArticle(_ article: Article) async throws
    func saveArticles(_ articles: [Article]) async throws
    func getArticle(_ id: Article.ID, updatedAfter: Date?) async throws -> Article?
    func removeArticles(ids: [Article.ID]) async throws
}
