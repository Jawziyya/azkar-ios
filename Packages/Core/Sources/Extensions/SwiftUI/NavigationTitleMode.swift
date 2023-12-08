import SwiftUI

public enum NavigationTitleMode {
    case automatic, large, inline
    /// Only available on iOS 17+
    case inlineLarge
}

public extension View {
    func navigationTitleMode(_ mode: NavigationTitleMode) -> some View {
        self.modifier(NavigationTitleModeModifier(mode: mode))
    }
}

public struct NavigationTitleModeModifier: ViewModifier {
    
    let mode: NavigationTitleMode
    
    public func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            let titleMode: ToolbarTitleDisplayMode
            switch mode {
            case .automatic: titleMode = .automatic
            case .inline: titleMode = .inline
            case .inlineLarge: titleMode = .inlineLarge
            case .large: titleMode = .large
            }
            return content.toolbarTitleDisplayMode(titleMode)
        } else {
            let titleMode: NavigationBarItem.TitleDisplayMode
            switch mode {
            case .automatic: titleMode = .automatic
            case .inline, .inlineLarge: titleMode = .inline
            case .large: titleMode = .large
            }
            return content.navigationBarTitleDisplayMode(titleMode)
        }
    }
    
}
