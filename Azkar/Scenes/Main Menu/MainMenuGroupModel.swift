// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import SwiftUI

enum IconType {
    case system
    case bundled
    case emoji
}

protocol AzkarMenuType {
    var title: String { get }
    var count: Int? { get }
    var color: Color { get }
    var image: Image? { get }
    var iconType: IconType { get }
    var imageName: String { get }
}

extension AzkarMenuType {
    var count: Int? { nil }
}

struct AzkarMenuItem: Identifiable, AzkarMenuType, Hashable {

    var id: String {
        title
    }

    let category: ZikrCategory
    let imageName: String
    let title: String
    let color: Color
    let count: Int?
    var iconType: IconType = .system

    var image: Image? {
        switch iconType {
        case .bundled:
            return Image(imageName).renderingMode(.original)
        case .system:
            return Image(systemName: imageName).renderingMode(.template)
        case .emoji:
            return nil
        }
    }

    static var demo: Self {
        AzkarMenuItem(category: .evening, imageName: "sun.max", title: UUID().uuidString, color: Color.blue, count: Int.random(in: 1...100))
    }

    static var noCountDemo: Self {
        AzkarMenuItem(category: .other, imageName: "sun.min", title: "Title", color: Color.green, count: nil, iconType: .system)
    }

}

struct AzkarMenuOtherItem: Identifiable, AzkarMenuType {

    static func == (lhs: AzkarMenuOtherItem, rhs: AzkarMenuOtherItem) -> Bool {
        return lhs.id == rhs.id
    }

    enum GroupType {
        case fadail, legal, settings, notificationsAccess
    }

    var groupType: GroupType?
	var imageName: String
	let title: String
	let color: Color
    var iconType = IconType.system
    var action: (() -> Void)?

    static var demo = AzkarMenuOtherItem(groupType: .fadail, imageName: "paperplane", title: "Test category", color: Color.init(.systemTeal))

    var image: Image? {
        switch iconType {
        case .bundled:
            return Image(imageName).renderingMode(.original)
        case .system: 
            return Image(systemName: imageName).renderingMode(.template)
        case .emoji:
            return nil
        }
    }

	var id: String { title }
    
}
