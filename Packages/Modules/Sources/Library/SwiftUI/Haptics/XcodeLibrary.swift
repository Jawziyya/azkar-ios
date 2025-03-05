import SwiftUI

/// Makes `.hapticFeedback` modifier available to Xcode's library,
/// allowing for improved auto-complete and discoverability.
public struct HapticFeedbackLibrary: LibraryContentProvider {
    @State var status: Status = .unknown
    
    @LibraryContentBuilder
    public func modifiers(base: any View) -> [LibraryItem] {
        LibraryItem(
            base.hapticFeedback(.impact, trigger: status),
            title: "Haptic Feedback"
        )
        LibraryItem(
            base.hapticFeedback(trigger: status) { _, newValue in
                return switch newValue {
                case .success: .success
                case .failure: .error
                default: nil
                }
            },
            title: "Dynamic Haptic Feedback"
        )
    }
    
    enum Status: Int {
        case unknown = 0
        case success = 1
        case failure = 2
    }
}

