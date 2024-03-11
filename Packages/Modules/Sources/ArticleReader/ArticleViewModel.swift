import Foundation
import Perception
import Entities

@Perceptible @dynamicMemberLookup
public final class ArticleViewModel {
    let article: Article
    let views: String?
    let shares: String?
    
    subscript<T>(dynamicMember keyPath: KeyPath<Article, T>) -> T {
        article[keyPath: keyPath]
    }
    
    public init(article: Article) {
        self.article = article
        
        let numberFormatter = NumberFormatter()
        numberFormatter.formattingContext = .standalone
        numberFormatter.maximumFractionDigits = 0
        views = numberFormatter.string(for: article.views)
        shares = numberFormatter.string(for: article.shares)
    }
}
