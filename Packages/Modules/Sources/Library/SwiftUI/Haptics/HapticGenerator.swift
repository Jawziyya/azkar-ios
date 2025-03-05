import SwiftUI

/// Trigger haptic feedback programmatically.
public class HapticGenerator {
    private init() { }
    
    /// Perform provided `feedback` instantly.
    /// - Parameter feedback: Which type of feedback to play.
    public static func performFeedback(_ feedback: HapticFeedback) {
        feedback.perform()
    }
}
