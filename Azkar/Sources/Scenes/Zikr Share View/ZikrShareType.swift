import SwiftUI

enum ZikrShareType: String, CaseIterable, Identifiable {
    case image, text, instagramStories

    static var availableCases: [ZikrShareType] {
        var cases = [ZikrShareType.image, .text]
        if UIApplication.shared.canOpenURL(Constants.INSTAGRAM_STORIES_URL) {
            cases.append(.instagramStories)
        }
        return cases
    }

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .text:
            return L10n.Share.text
        case .image:
            return L10n.Share.image
        case .instagramStories:
            return "Instagram Stories"
        }
    }

    var imageName: String {
        switch self {
        case .image:
            return "photo"
        case .text:
            return "doc.plaintext"
        case .instagramStories:
            return "circle.fill.square.fill"
        }
    }
}
