import SwiftUI

enum CounterSize: String, Codable, CaseIterable, Identifiable {
    case small, medium, large
    
    var id: String {
        rawValue
    }
    
    var value: CGFloat {
        switch self {
        case .small: return 45
        case .medium: return 55
        case .large: return 65
        }
    }
    
    var title: String {
        switch self {
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
        }
    }
}
