import Foundation

public enum ZikrTransliterationType: String, CaseIterable, Codable, Hashable, Identifiable {
    case community
    case DIN31635
    case ruScientific
    
    public var id: String {
        return rawValue
    }
        
    public var title: String? {
        switch self {
        case .ruScientific: return "Научная транскрипция (И. А. Крачковский)"
        case .DIN31635: return "DIN 31635"
        case .community: return nil
        }
    }
}
