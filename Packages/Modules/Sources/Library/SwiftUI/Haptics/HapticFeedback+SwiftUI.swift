import SwiftUI

extension View {
    @ViewBuilder
    /// Plays the specified `feedback` when the provided `trigger` value changes.
    ///
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///
    /// For example, you could play feedback when a state value changes:
    ///
    /// ```swift
    /// struct MyView: View {
    ///     @State private var showAccessory = false
    ///
    ///     var body: some View {
    ///         ContentView()
    ///            .hapticFeedback(.selection, trigger: showAccessory)
    ///            .onLongPressGesture {
    ///                showAccessory.toggle()
    ///            }
    ///
    ///        if showAccessory {
    ///            AccessoryView()
    ///        }
    ///    }
    /// }
    /// ```
    public func hapticFeedback<T: Equatable>(
        _ feedback: HapticFeedback,
        trigger: T
    ) -> some View {
        if #available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, macCatalyst 17.0, visionOS 1.0, *) {
            onChange(of: trigger) {
                feedback.perform()
            }
        } else {
            onChange(of: trigger) { _ in
                feedback.perform()
            }
        }
    }
    
    @ViewBuilder
    /// Plays feedback when returned from the `feedback` closure after the provided `trigger` value changes.
    ///
    /// - Parameters:
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - feedback: A closure to determine whether to play the feedback and what type of feedback to play when trigger changes.
    ///
    /// For example, you could play different feedback for different state transitions:
    ///
    /// ```swift
    /// struct MyView: View {
    ///     @State private var phase = Phase.inactive
    ///
    ///     var body: some View {
    ///         ContentView(phase: $phase)
    ///             .hapticFeedback(trigger: phase) { old, new in
    ///                 switch (old, new) {
    ///                     case (.inactive, _): return .success
    ///                     case (_, .expanded): return .impact
    ///                     default: return nil
    ///                 }
    ///             }
    ///     }
    ///
    ///     enum Phase {
    ///         case inactive
    ///         case preparing
    ///         case active
    ///         case expanded
    ///     }
    /// }
    /// ```
    public func hapticFeedback<T: Equatable>(
        trigger: T,
        _ feedback: @escaping (T, T) -> HapticFeedback?
    ) -> some View {
        if #available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, macCatalyst 17.0, visionOS 1.0, *) {
            onChange(of: trigger) { oldValue, newValue in
                feedback(oldValue, newValue)?.perform()
            }
        } else {
            onChange(of: trigger) { [oldValue = trigger] newValue in
                feedback(oldValue, newValue)?.perform()
            }
        }
    }
    
    @ViewBuilder
    /// Plays the specified `feedback` when the provided `trigger` value changes and the `condition` closure returns `true`.
    /// - Parameters:
    ///   - feedback: Which type of feedback to play.
    ///   - trigger: A value to monitor for changes to determine when to play.
    ///   - condition: A closure to determine whether to play the feedback when trigger changes.
    ///
    /// For example, you could play feedback for certain state transitions:
    ///
    /// ```swift
    /// struct MyView: View {
    ///     @State private var phase = Phase.inactive
    ///
    ///     var body: some View {
    ///         ContentView(phase: $phase)
    ///             .hapticFeedback(.selection, trigger: phase) { old, new in
    ///                 old == .inactive || new == .expanded
    ///             }
    ///     }
    ///
    ///     enum Phase {
    ///         case inactive
    ///         case preparing
    ///         case active
    ///         case expanded
    ///     }
    /// }
    /// ```
    public func hapticFeedback<T: Equatable>(
        _ feedback: HapticFeedback,
        trigger: T,
        condition: @escaping (T, T) -> Bool
    ) -> some View {
        if #available(iOS 17.0, macOS 14.0, watchOS 10.0, tvOS 17.0, macCatalyst 17.0, visionOS 1.0, *) {
            onChange(of: trigger) { oldValue, newValue in
                condition(oldValue, newValue) ? feedback.perform() : ()
            }
        } else {
            onChange(of: trigger) { [oldValue = trigger] newValue in
                condition(oldValue, newValue) ? feedback.perform() : ()
            }
        }
    }
}
