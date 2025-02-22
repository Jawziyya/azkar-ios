import SwiftUI

public extension List {
    
    enum AListSpacing {
        case compact, `default`, custom(CGFloat)
    }
    
    /// Sets the spacing between adjacent sections in a List.
    ///
    /// - Note: iOS < 17 backwards compatibility extension.
    ///
    /// Pass `.default` for the default spacing, or use `.compact` for
    /// a compact appearance between sections.
    ///
    /// The following example creates a List with compact spacing between
    /// sections:
    ///
    ///     List {
    ///         Section("Colors") {
    ///             Text("Blue")
    ///             Text("Red")
    ///         }
    ///
    ///         Section("Shapes") {
    ///             Text("Square")
    ///             Text("Circle")
    ///         }
    ///     }
    ///     .listSectionSpacing(.compact)
    func customListSectionSpacing(_ spacing: AListSpacing) -> some View {
        if #available(iOS 17, *) {
            let sectionSpacing: ListSectionSpacing
            switch spacing {
            case .compact: sectionSpacing = .compact
            case .default: sectionSpacing = .default
            case .custom(let value): sectionSpacing = .custom(value)
            }
            return listSectionSpacing(sectionSpacing)
        } else {
            return self
        }
    }
    
}
