import Foundation

public enum ZikrReadingMode: String, Codable, CaseIterable, Identifiable {
    case normal, lineByLine
    
    public var id: Self { self }
    
    public var title: String {
        switch self {
        case .normal: NSLocalizedString("settings.text.reading_mode.normal", comment: "")
        case .lineByLine: NSLocalizedString("settings.text.reading_mode.line_by_line", comment: "")
        }
    }
}
