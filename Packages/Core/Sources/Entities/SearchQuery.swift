import Foundation

public struct SearchQuery: Identifiable, Hashable, Codable {
    public let id: Int?
    public let text: String
    public var date: Date
    
    public init(id: Int? = nil, text: String, date: Date) {
        self.id = id
        self.text = text
        self.date = date
    }
}
