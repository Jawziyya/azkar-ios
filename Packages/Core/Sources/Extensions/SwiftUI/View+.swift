import SwiftUI

public extension View {
    
    @ViewBuilder
    func applyAccessibilityLabel(_ label: String?) -> some View {
        if let label {
            self.accessibilityLabel(Text(label))
        } else {
            self
        }
    }
    
}
