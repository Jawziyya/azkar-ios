import Foundation
import Perception
import Entities

@Perceptible @dynamicMemberLookup
public final class ArticleViewModel {
    let article: Article
    
    subscript<T>(dynamicMember keyPath: KeyPath<Article, T>) -> T {
        article[keyPath: keyPath]
    }
    
    public init(article: Article) {
        self.article = article
    }
}
