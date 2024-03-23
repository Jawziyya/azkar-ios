import Foundation
import Perception
import Entities

@Perceptible @dynamicMemberLookup
public final class ArticleViewModel {
    
    let article: Article
    var views: String?
    var viewsAbbreviated: String?
    var shares: String?
    var sharesAbbreviated: String?
    
    subscript<T>(dynamicMember keyPath: KeyPath<Article, T>) -> T {
        article[keyPath: keyPath]
    }
    
    public init(article: Article) {
        self.article = article
        
        let numberFormatter = NumberFormatter()
        numberFormatter.formattingContext = .standalone
        numberFormatter.maximumFractionDigits = 0
        if let views = article.views, views > 0 {
            self.views = numberFormatter.string(for: views)
            viewsAbbreviated = views.toAbbreviatedString()
        }
        if let shares = article.shares, shares > 0 {
            self.shares = numberFormatter.string(for: shares)
            sharesAbbreviated = shares.toAbbreviatedString()
        }
    }
    
}
