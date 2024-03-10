import Foundation

enum ZikrReadingMode: String, Codable, CaseIterable, Identifiable {
    case normal, lineByLine
    
    var id: Self { self }
    
    var title: String {
        rawValue
    }
}
