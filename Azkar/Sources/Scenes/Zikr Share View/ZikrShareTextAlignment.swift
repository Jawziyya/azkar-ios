import SwiftUI

enum ZikrShareTextAlignment: String, Identifiable, CaseIterable {
    case start, center

    public var id: String {
        imageName
    }

    var imageName: String {
        switch self {
        case .start:
            return "text.alignright"
        case .center:
            return "text.aligncenter"
        }
    }

    var isCentered: Bool {
        self == .center
    }
}
