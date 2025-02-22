import Foundation

public struct ZikrCounter: Identifiable, Hashable, Codable {
    public let id: Int?
    public let key: Int
    public let zikrId: Int
    public let category: ZikrCategory?
    
    public init(key: Int, zikrId: Int, category: ZikrCategory?) {
        id = nil
        self.key = key
        self.zikrId = zikrId
        self.category = category
    }
}
