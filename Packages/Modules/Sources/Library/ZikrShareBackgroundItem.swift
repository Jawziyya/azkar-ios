import SwiftUI
import Entities

public struct ZikrShareBackgroundItem: Identifiable, Hashable {
    public let id: String
    public let background: Background
    public let type: ShareBackgroundType
    public var isProItem = true

    public enum Background: Hashable {
        case solidColor(UIColor)
        case localImage(UIImage)
        case remoteImage(ShareBackground)
    }

    public init(id: String, background: Background, type: ShareBackgroundType, isProItem: Bool = true) {
        self.id = id
        self.background = background
        self.type = type
        self.isProItem = isProItem
    }
}
