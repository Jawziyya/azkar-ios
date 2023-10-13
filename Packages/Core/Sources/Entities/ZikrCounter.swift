import Foundation

public struct ZikrCounter: Identifiable, Hashable, Codable {
    public let id: Int?
    public let key: Int
    public let zikrId: Int
    
    public init(key: Int, zikrId: Int) {
        id = nil
        self.key = key
        self.zikrId = zikrId
    }
}
