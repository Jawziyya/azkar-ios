import SwiftUI

enum ZikrShareType: String, CaseIterable, Identifiable {
    case image, text

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .text:
            return L10n.Share.text
        case .image:
            return L10n.Share.image
        }
    }

    var imageName: String {
        switch self {
        case .image:
            return "photo"
        case .text:
            return "doc.plaintext"
        }
    }
}
