import SwiftUI
import Entities

@dynamicMemberLookup
public final class ArticleViewModel: ObservableObject {
    
    var article: Article
    @Published var views: Int?
    @Published var viewsAbbreviated: String?
    @Published var shares: Int?
    @Published var sharesAbbreviated: String?
    
    private let analyticsStream: () async -> AsyncStream<ArticleAnalytics>
    private let updateAnalytics: (ArticleAnalytics) async -> Void
    private let fetchArticle: () async -> Article?
    
    subscript<T>(dynamicMember keyPath: KeyPath<Article, T>) -> T {
        article[keyPath: keyPath]
    }
    
    public init(
        article: Article,
        analyticsStream: @escaping () async -> AsyncStream<ArticleAnalytics>,
        updateAnalytics: @escaping (ArticleAnalytics) async -> Void,
        fetchArticle: @escaping () async -> Article?
    ) {
        self.article = article
        self.analyticsStream = analyticsStream
        self.updateAnalytics = updateAnalytics
        self.fetchArticle = fetchArticle
        updateNumbers()
        
        Task {
            await observeAnalyticsNumbers()
        }
        
        Task(priority: .utility) {
            await updateArticle()
        }
    }
    
    @MainActor private func observeAnalyticsNumbers() async {
        for await numbers in await analyticsStream() {
            withAnimation(.spring) {
                setViews(numbers.viewsCount)
                setShares(numbers.sharesCount)
            }
            Task.detached {
                await self.updateAnalytics(numbers)
            }
        }
    }
    
    @MainActor private func updateArticle() async {
        if let updatedArticle = await fetchArticle() {
            self.article = updatedArticle
            self.updateNumbers()
        }
    }
    
    private func updateNumbers() {
        if let views = article.views {
            setViews(views)
        }
        if let shares = article.shares {
            setShares(shares)
        }
    }
    
    private func setViews(_ number: Int) {
        views = number
        viewsAbbreviated = number.toAbbreviatedString()
    }
    
    private func setShares(_ number: Int) {
        shares = number
        sharesAbbreviated = number.toAbbreviatedString()
    }
    
}
