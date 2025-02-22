import Foundation

public enum SymbolType: Hashable {
    case harf(Harf)
    case harfExtension(HarfExtension)
    case tashkeel(Tashkeel)
    case special(SpecialCharacter)
    
    // Custom Equatable implementation to compare SymbolType with Harf
    public static func ==(lhs: SymbolType, rhs: Harf) -> Bool {
        if case .harf(let harf) = lhs {
            return harf == rhs
        }
        return false
    }
    
    // Custom Equatable implementation to compare SymbolType with Tashkeel
    public static func ==(lhs: SymbolType, rhs: Tashkeel) -> Bool {
        if case .tashkeel(let tashkeel) = lhs {
            return tashkeel == rhs
        }
        return false
    }
}
