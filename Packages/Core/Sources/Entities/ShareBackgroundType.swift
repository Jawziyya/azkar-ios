import SwiftUI

public enum ShareBackgroundType: String, Codable, Hashable, CaseIterable, Identifiable {
    case color
    case pattern
    case image
    
    public var id: Self { self }

    public var title: String {
        switch self {
        case .color: NSLocalizedString("share.background-type.color", comment: "")
        case .image: NSLocalizedString("share.background-type.image", comment: "")
        case .pattern: NSLocalizedString("share.background-type.pattern", comment: "")
        }
    }
}
