import SwiftUI

public extension Color {
    
    private static func getColor(_ name: String = #function) -> Color {
        if let color = UIColor(named: ColorTheme.current.assetsNamespace + name, in: Bundle.main, compatibleWith: nil) {
            return Color(color)
        } else {
            return Color(name)
        }
    }

    static var accent: Color {
        getColor()
    }

    static var liteAccent: Color {
        getColor()
    }
    
    static var text: Color {
        getColor()
    }
    
    static var secondaryText: Color {
        getColor()
    }

    static var tertiaryText: Color {
        getColor()
    }

    static var background: Color {
        getColor()
    }
    
    static var contentBackground: Color {
        getColor()
    }

    static var secondaryBackground: Color {
        getColor()
    }

    static var dimmedBackground: Color {
        getColor()
    }
    
}
