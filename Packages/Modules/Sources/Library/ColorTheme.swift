import Foundation

public enum ColorTheme: String, CaseIterable, Equatable, Codable {
    
    public static var current = ColorTheme.default
    
    case `default`, sea, purpleRose, ink, roseQuartz
    
    public var colorsNamespacePrefix: String {
        switch self {
        case .default: return ""
        case .sea: return "Sea/"
        case .purpleRose: return "PurpleRose/"
        case .ink: return "Ink/"
        case .roseQuartz: return "RoseQuartz/"
        }
    }
}
