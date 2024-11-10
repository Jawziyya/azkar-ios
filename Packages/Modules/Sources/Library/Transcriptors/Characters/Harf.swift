import Foundation

public enum Harf: Character, Hashable, CaseIterable, Sendable, CustomDebugStringConvertible {
    
    enum HarfKind {
        case shamsiyyah, qamariyyah
    }
    
    public var debugDescription: String {
        return "\(rawValue) \(unicodeCode)"
    }
    
    private var unicodeCode: String {
        "\\u{\(String(format: "%04X", rawValue.unicodeScalars.first?.value ?? 0))}"
    }
        
    var kind: HarfKind {
        switch self {
        case .ta, .tha, .dal, .thal, .ra, .zay, .seen, .sheen, .sad, .dad, .tah, .zah, .lam, .noon:
            return .shamsiyyah
        case .ba, .jeem, .hha, .kha, .ain, .ghain, .fa, .qaf, .kaf, .meem, .ha, .waw, .ya:
            return .qamariyyah
        default:
            return .qamariyyah
        }
    }
    
    func isShamsiyyah() -> Bool {
        kind == .shamsiyyah
    }
        
    // Arabic Characters
    case alif = "\u{0627}" // ا
    case ba = "\u{0628}" // ب
    case taMarbuta = "\u{0629}" // ة
    case ta = "\u{062A}" // ت
    case tha = "\u{062B}" // ث
    case jeem = "\u{062C}" // ج
    case hha = "\u{062D}" // ح
    case kha = "\u{062E}" // خ
    case dal = "\u{062F}" // د
    case thal = "\u{0630}" // ذ
    case ra = "\u{0631}" // ر
    case zay = "\u{0632}" // ز
    case seen = "\u{0633}" // س
    case sheen = "\u{0634}" // ش
    case sad = "\u{0635}" // ص
    case dad = "\u{0636}" // ض
    case tah = "\u{0637}" // ط
    case zah = "\u{0638}" // ظ
    case ain = "\u{0639}" // ع
    case ghain = "\u{063A}" // غ
    case fa = "\u{0641}" // ف
    case qaf = "\u{0642}" // ق
    case kaf = "\u{0643}" // ك
    case lam = "\u{0644}" // ل
    case meem = "\u{0645}" // م
    case noon = "\u{0646}" // ن
    case ha = "\u{0647}" // ه
    case waw = "\u{0648}" // و
    case ya = "\u{064A}" // ي
    case hamza = "\u{0621}" // ء
}
