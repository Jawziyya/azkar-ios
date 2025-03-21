import SwiftUI
import Entities
import Extensions

extension AdSize {
    var scale: CGFloat {
        switch self {
        case .minimal: return 0.65
        case .regular: return 1
        }
    }
    
    var titleFont: Font {
        switch self {
        case .minimal: return Font.callout.weight(.medium)
        case .regular: return Font.headline
        }
    }
    
    var bodyFont: Font {
        switch self {
        case .minimal: return Font.caption
        case .regular: return Font.footnote
        }
    }
    
    var actionFont: Font {
        switch self {
        case .minimal: return Font.caption2.weight(.semibold)
        case .regular: return Font.body.weight(.semibold)
        }
    }
}

public struct AdButtonItem: Identifiable {
    public let id: Int
    let size: AdSize
    let title: String?
    let body: String?
    let actionTitle: String?
    let actionLink: URL
    let foregroundColor: Color?
    let accentColor: Color
    let backgroundColor: Color?
    let imageLink: URL?
    let imageMode: AdImageMode?
}

extension AdButtonItem {
    public init(ad: Ad) {
        self.id = ad.id
        size = ad.size
        title = ad.title
        body = ad.body
        actionTitle = ad.actionTitle
        actionLink = ad.actionLink
        accentColor = ad.accentColor.flatMap(Color.init(hex:)) ?? Color.accentColor
        foregroundColor = ad.foregroundColor.flatMap(Color.init(hex:))
        backgroundColor = ad.backgroundColor.flatMap(Color.init(hex:))
        imageLink = ad.imageLink
        imageMode = ad.imageMode
    }
}
