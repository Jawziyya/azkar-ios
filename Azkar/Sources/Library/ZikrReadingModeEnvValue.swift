import SwiftUI
import Library

private struct ZikrReadingModeKey: EnvironmentKey {
    static let defaultValue: ZikrReadingMode = .normal
}

extension EnvironmentValues {
    var zikrReadingMode: ZikrReadingMode {
        get { self[ZikrReadingModeKey.self] }
        set { self[ZikrReadingModeKey.self] = newValue }
    }
}
