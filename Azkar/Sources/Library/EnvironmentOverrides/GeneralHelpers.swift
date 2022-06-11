import SwiftUI

// MARK: - Bindings

extension Binding {
    
    func map<T>(toValue: @escaping (Value) -> T,
                fromValue: @escaping (T) -> Value) -> Binding<T> {
        return .init(get: {
            toValue(self.wrappedValue)
        }, set: { value in
            self.wrappedValue = fromValue(value)
        })
    }
    
    func onChange(_ perform: @escaping (Value) -> Void) -> Binding<Value> {
        return .init(get: {
            self.wrappedValue
        }, set: { value in
            self.wrappedValue = value
            perform(value)
        })
    }
}

extension EnvironmentValues {
    
    static var isMac: Bool {
        #if targetEnvironment(macCatalyst) || os(macOS)
        return true
        #else
        return false
        #endif
    }
}

// MARK: - Haptic
struct Haptic {

    static func tapFeedback() {
        #if !os(macOS)
        UISelectionFeedbackGenerator().selectionChanged()
        #endif
    }
    
    static func successFeedback() {
        #if !os(macOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
    }
    
    static func errorFeedback() {
        #if !os(macOS)
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        #endif
    }
    
    static func toggleFeedback() {
        #if !os(macOS)
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        #endif
    }
}
