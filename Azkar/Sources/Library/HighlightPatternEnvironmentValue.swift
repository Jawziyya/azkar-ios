import SwiftUI

private struct HighlightPatternKey: EnvironmentKey {
    static let defaultValue: String? = nil
}

extension EnvironmentValues {
    var highlightPattern: String? {
        get { self[HighlightPatternKey.self] }
        set { self[HighlightPatternKey.self] = newValue }
    }
}
