// ASCollectionView. Created by Apptek Studios 2019

import Foundation
import SwiftUI

enum IconType {
    case system
    case bundled
}

protocol AzkarMenuType {
    var title: String { get }
    var count: Int? { get }
    var color: Color { get }
    var image: Image? { get }
}

extension AzkarMenuType {
    var count: Int? { nil }
}

struct AzkarMenuItem: Identifiable, AzkarMenuType {

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
        }
    }

    static var demo: Self {
        AzkarMenuItem(category: .evening, imageName: "sun.max", title: UUID().uuidString, color: Color.blue, count: Int.random(in: 1...100))
    }

}

struct AzkarMenuOtherItem: Identifiable, AzkarMenuType {

    enum GroupType {
        case fadail, legal, settings, notificationsAccess
    }

    let groupType: GroupType
	let icon: String?
	let title: String
	let color: Color
    var iconType = IconType.system

    static var demo = AzkarMenuOtherItem(groupType: .fadail, icon: "paperplane", title: "Test category", color: Color.init(.systemTeal))

    var image: Image? {
        guard let icon = icon else { return nil }
        switch iconType {
        case .bundled:
            return Image(icon).renderingMode(.original)
        case .system:
            return Image(systemName: icon).renderingMode(.template)
        }
    }

	var id: String { title }
    
}
