import SwiftUI

enum CounterType: Int, Codable, CaseIterable, Identifiable {
    case floatingButton, tap

    var id: Int {
        rawValue
    }

    var title: String {
        switch self {
        case .floatingButton: return L10n.Settings.Counter.CounterType.button
        case .tap: return L10n.Settings.Counter.CounterType.tap
        }
    }
}
