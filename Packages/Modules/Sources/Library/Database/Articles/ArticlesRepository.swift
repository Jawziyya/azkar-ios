import Foundation
import Entities

protocol ArticlesRepository {
    func getArticles(limit: Int, newerThan: Date?) async throws -> [Article]
    func saveArticle(_ article: Article) async throws
    func saveArticles(_ articles: [Article]) async throws
    func getArticle(_ id: ArticleDTO.ID) async throws -> Article?
}
