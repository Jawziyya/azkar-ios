import SwiftUI

public enum ColorTheme: String, CaseIterable, Equatable, Codable, Identifiable {
    
    public var id: Self {
        self
    }
    
    public static var current = ColorTheme.default
    
    case `default`, sea, purpleRose, ink, roseQuartz
    
    public var assetsNamespace: String {
        switch self {
        case .sea: return "ColorThemes/Sea/"
        case .purpleRose: return "ColorThemes/PurpleRose/"
        case .ink: return "ColorThemes/Ink/"
        case .roseQuartz: return "ColorThemes/RoseQuartz/"
        default: return ""
        }
    }
    
    public var isBlackWhite: Bool {
        switch self {
        case .ink: return true
        default: return false
        }
    }
        
}
