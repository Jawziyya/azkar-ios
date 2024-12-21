import SwiftUI

private struct ZikrReadingModeKey: EnvironmentKey {
    static let defaultValue: ZikrReadingMode = .normal
}

extension EnvironmentValues {
    public var zikrReadingMode: ZikrReadingMode {
        get { self[ZikrReadingModeKey.self] }
        set { self[ZikrReadingModeKey.self] = newValue }
    }
}
