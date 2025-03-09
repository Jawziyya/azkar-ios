import SwiftUI

enum CounterPosition: String, Codable, CaseIterable, Identifiable {
    case left, center, right
    
    var id: String {
        rawValue
    }
    
    var title: String {
        return NSLocalizedString("settings.counter.counter-position." + rawValue, comment: "")
    }
    
    var alignment: Alignment {
        switch self {
        case .left: return .bottomLeading
        case .center: return .bottom
        case .right: return .bottomTrailing
        }
    }
}
