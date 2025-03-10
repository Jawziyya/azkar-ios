import SwiftUI

public enum AppTheme: String, CaseIterable, Hashable, Codable, Identifiable {
    
    case `default`, reader, flat, neomorphic, code
    
    public static var enabledThemes: [AppTheme] {
        [.default, .reader, .flat, .code]
    }
    
    public var id: Self {
        self
    }
    
    public struct ShadowStyle {
        public let offset: CGPoint
        public let color: Color
        public let radius: CGFloat
    }
    
    public static var current = AppTheme.default
    
    public var assetsNamespace: String {
        switch self {
        case .reader: return "AppThemes/Reader/"
        case .flat: return "AppThemes/Flat/"
        case .neomorphic: return "AppThemes/Neomorphic/"
        case .code: return "AppThemes/Code/"
        default: return ""
        }
    }
    
    public var isBlackWhite: Bool {
        switch self {
        case .reader: return true
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
