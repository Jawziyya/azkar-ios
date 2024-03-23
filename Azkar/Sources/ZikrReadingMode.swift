import Foundation

enum ZikrReadingMode: String, Codable, CaseIterable, Identifiable {
    case normal, lineByLine
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .normal: return L10n.Settings.Text.ReadingMode.normal
        case .lineByLine: return L10n.Settings.Text.ReadingMode.lineByLine
        }
    }
}
