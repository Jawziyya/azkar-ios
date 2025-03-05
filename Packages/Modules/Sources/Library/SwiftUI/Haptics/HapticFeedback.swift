import Foundation

protocol Haptic: Sendable {
    @MainActor var performHapticFeedback: @Sendable () async -> Void { get }
}

/// Represents a type of haptic and/or audio feedback that can be played.
///
/// This feedback can be passed to `View.hapticFeedback` to play it.
public struct HapticFeedback: Haptic {
    internal var label: String
    internal var performHapticFeedback: @Sendable () async -> Void
    
    init(_ label: String, performHapticFeedback: @MainActor @escaping @Sendable () -> Void) {
        self.label = label
        self.performHapticFeedback = performHapticFeedback
    }
    
    /// Perform feedback in Main Actor.
    func perform() {
        Task { @MainActor in
            await self.performHapticFeedback()
        }
    }
}

extension HapticFeedback {
    /// The flexibility to be represented by a type of feedback.
    ///
    /// Flexibility values can be passed to `HapticFeedback.impact(flexibility:intensity:)`.
    public enum Flexibility: Int, Sendable {
        case rigid, solid, soft
    }
    
    /// The weight to be represented by a type of feedback.
    ///
    /// Weight values can be passed to `HapticFeedback.impact(weight:intensity:)`.
    public enum Weight: Int, Sendable {
        case light, medium, heavy
    }
}

extension HapticFeedback: Equatable {
    public static func == (lhs: HapticFeedback, rhs: HapticFeedback) -> Bool {
        lhs.label == rhs.label
    }
}
