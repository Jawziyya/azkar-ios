import Foundation

public enum ZikrCategory: String, Codable, Equatable {
    case morning, evening, night, afterSalah = "after-salah", other

    public var title: String {
        return NSLocalizedString("category." + rawValue, comment: "")
    }
}
