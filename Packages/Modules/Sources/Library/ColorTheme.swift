import SwiftUI

public enum ColorTheme: String, CaseIterable, Equatable, Codable, Identifiable {
    
    public var id: Self {
        self
    }
    
    public struct ShadowStyle {
        public let offset: CGPoint
        public let color: Color
        public let radius: CGFloat
    }
    
    public struct BorderStyle {
        public let color: Color
        public let width: CGFloat
    }
    
    public static var current = ColorTheme.default
    
    public static var legacyThemes: [ColorTheme] = [.default, .sea, .purpleRose, .ink, .roseQuartz]
    public static var modernThemes: [ColorTheme] = [.reader, .flat, .neomorphic, .code]
    
    case `default`, sea, purpleRose, ink, roseQuartz
    case reader, flat, neomorphic, code
    
    public var assetsNamespace: String {
        switch self {
        case .sea: return "Sea/"
        case .purpleRose: return "PurpleRose/"
        case .ink: return "Ink/"
        case .roseQuartz: return "RoseQuartz/"
        case .reader: return "Reader/"
        case .flat: return "Flat/"
        case .neomorphic: return "Neomorphic/"
        case .code: return "Code/"
        default: return ""
        }
    }
    
    public var isBlackWhite: Bool {
        switch self {
        case .ink, .reader: return true
        default: return false
        }
    }
    
    public var cornerRadius: CGFloat {
        switch self {
        case .reader: return 10
        case .flat: return 0
        case .code: return 0
        default: return 15
        }
    }
    
    public var shadowStyle: ShadowStyle? {
        switch self {
        case .flat:
            return ShadowStyle(
                offset: CGPoint(x: 5, y: 5),
                color: Color.black.opacity(0.75),
                radius: 0
            )
        default:
            return nil
        }
    }
    
    public var borderStyle: BorderStyle? {
        switch self {
        case .reader: return BorderStyle(color: Color.text, width: 1)
        case .flat: return BorderStyle(color: Color.accent, width: 1)
        default: return nil
        }
    }
    
    public var fontDesign: Font.Design {
        switch self {
        case .reader: return .serif
        case .code: return .monospaced
        default: return .default
        }
    }
    
    public var font: String? {
        switch self {
        case .code: return "Menlo-Regular"
        default: return nil
        }
    }
    
}
