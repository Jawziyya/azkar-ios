import SwiftUI

public enum ColorTheme: String, CaseIterable, Hashable, Codable, Identifiable {
    
    public var id: Self {
        self
    }
    
    public static var current = ColorTheme.default
    
    case `default`, sea, forest, purpleRose, ink, roseQuartz
    
    public var assetsNamespace: String {
        switch self {
        case .sea: return "ColorThemes/Sea/"
        case .purpleRose: return "ColorThemes/PurpleRose/"
        case .ink: return "ColorThemes/Ink/"
        case .roseQuartz: return "ColorThemes/RoseQuartz/"
        case .forest: return "ColorThemes/Forest/"
        default: return ""
        }
    }
    
    public var isBlackWhite: Bool {
        switch self {
        case .ink: return true
        default: return false
        }
    }
    
    public func getColor(_ type: ColorType, opacity: Double = 1) -> Color {
        Color.getColor(type, theme: self).opacity(opacity)
    }
        
}
