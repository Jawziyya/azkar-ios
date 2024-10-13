import SwiftUI
import Perception
import Entities

@Perceptible @dynamicMemberLookup
public final class ArticleViewModel {
    
    let article: Article
    var views: Int?
    var viewsAbbreviated: String?
    var shares: Int?
    var sharesAbbreviated: String?
    
    private let analyticsStream: () async -> AsyncStream<ArticleAnalytics>
    private let updateAnalytics: (ArticleAnalytics) async -> Void
    
    subscript<T>(dynamicMember keyPath: KeyPath<Article, T>) -> T {
        article[keyPath: keyPath]
    }
    
    public init(
        article: Article,
        analyticsStream: @escaping () async -> AsyncStream<ArticleAnalytics>,
        updateAnalytics: @escaping (ArticleAnalytics) async -> Void
    ) {
        self.article = article
        self.analyticsStream = analyticsStream
        self.updateAnalytics = updateAnalytics
        if let views = article.views {
            setViews(views)
        }
        if let shares = article.shares {
            setShares(shares)
        }
        
        Task {
            await observeAnalyticsNumbers()
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
    
    private func setViews(_ number: Int) {
        views = number
        viewsAbbreviated = number.toAbbreviatedString()
    }
    
    private func setShares(_ number: Int) {
        shares = number
        sharesAbbreviated = number.toAbbreviatedString()
    }
    
}
