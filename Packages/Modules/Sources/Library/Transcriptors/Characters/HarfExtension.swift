import Foundation

public enum HarfExtension: Character, CaseIterable, Hashable {
    case alifHamzaBelow = "\u{0625}" // إ
    case hamzaAbove = "\u{0654}"
    case alifKhanjareeya = "\u{0670}" //
    case alifWaslaAbove = "\u{0671}" // ٱ
    case alifMaddaAbove = "\u{0622}" // آ
    case alifHamzaAbove = "\u{0623}" // أ
    case wawHamzaAbove = "\u{0624}" // ؤ
    case yaHamzaAbove = "\u{0626}" // ئ
    case alifMaksura = "\u{0649}" // ى
    case maddah = "\u{0653}"
}
