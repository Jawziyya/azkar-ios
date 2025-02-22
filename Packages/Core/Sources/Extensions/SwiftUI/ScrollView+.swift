import SwiftUI

public extension View {
    func automaticKeyboardDismissing() -> some View {
        if #available(iOS 16, *) {
            return scrollDismissesKeyboard(.immediately)
        } else {
            return self
        }
    }
}
