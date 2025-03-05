import Foundation

public enum Tashkeel: Character, Hashable, CaseIterable, Sendable, CustomDebugStringConvertible {
    
    public var debugDescription: String {
        let mirror = Mirror(reflecting: self)
        return "\(mirror.subjectType) \(rawValue)"
    }
    
    case damma = "\u{064f}"
    case dammatan = "\u{064c}"
    
    case fatha = "\u{064e}"
    case fathatan = "\u{064b}"
    
    case kasra = "\u{0650}"
    case kasratan = "\u{064d}"
    
    case shadda = "\u{0651}"
    case sukun = "\u{0652}"
    
    public static let normalVowels = [damma, fatha, kasra]
    public static let tanweenVowels = [dammatan, fathatan, kasratan]
    
}
