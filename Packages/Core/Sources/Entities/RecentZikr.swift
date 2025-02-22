import Foundation

public struct RecentZikr: Identifiable, Hashable, Codable {
    public var id: Int?
    public let zikrId: Int
    public var date: Date
    public let language: Language
    
    public init(id: Int? = nil, zikrId: Int, date: Date, language: Language) {
        self.id = id
        self.zikrId = zikrId
        self.date = date
        self.language = language
    }
}

