import Foundation
import Entities

enum ArticlesServiceError: Error {
    case localRepositoryUnavailable
    case failedToFetchArticles(Error)
    case failedToSaveArticles(Error)
}

/// A protocol that defines the interface for managing articles and their analytics.
public protocol ArticlesServiceType {

    /// Fetches a list of articles, up to a specified limit.
    ///
    /// This method returns an asynchronous stream of articles, allowing you to
    /// fetch multiple articles at once. The stream can throw an error if the fetching
    /// operation fails.
    ///
    /// - Parameter limit: The maximum number of articles to fetch.
    /// - Returns: An `AsyncThrowingStream` that provides an array of `Article` objects
    ///   or throws an error.
    func getArticles(limit: Int) -> AsyncThrowingStream<[Article], Error>
    
    /// Retrieves a specific article by its ID.
    ///
    /// This method fetches a single article asynchronously. It can throw an error if
    /// the fetch operation fails or the article does not exist.
    ///
    /// - Parameter id: The unique identifier of the article to fetch.
    /// - Returns: The `Article` object if found, or `nil` if the article doesn't exist.
    func getArticle(_ id: Article.ID) async throws -> Article?
    
    /// Sends an analytics event for a specific article.
    ///
    /// This method is used to log analytics events (e.g., views, shares) for a specific
    /// article, allowing you to track user interactions.
    ///
    /// - Parameters:
    ///   - type: The type of analytics event being recorded (e.g., view, share).
    ///   - articleId: The unique identifier of the article related to the event.
    func sendAnalyticsEvent(
        _ type: AnalyticsRecord.ActionType,
        articleId: Article.ID
    )
    
    /// Fetches and observes real-time analytics numbers for a specific article.
    ///
    /// This method creates an asynchronous stream of analytics data for an article,
    /// allowing you to observe real-time updates, such as changes in view or share counts.
    ///
    /// - Parameter articleId: The unique identifier of the article for which to observe analytics.
    /// - Returns: An `AsyncStream` that provides real-time `ArticleAnalytics` updates.
    func observeAnalyticsNumbers(articleId: Article.ID) async -> AsyncStream<ArticleAnalytics>
    
    /// Updates the local analytics numbers for a specific article.
    ///
    /// This method allows you to update the local record of an article's analytics data
    /// (e.g., views and shares). It is useful for synchronizing the local state with remote updates.
    ///
    /// - Parameters:
    ///   - articleId: The unique identifier of the article to update.
    ///   - views: The new number of views for the article.
    ///   - shares: The new number of shares for the article.
    func updateAnalyticsNumbers(
        for articleId: Article.ID,
        views: Int,
        shares: Int
    )
    
}
