import Foundation

public struct AnalyticsRecord: Decodable {
    public enum RecordType: String, Codable {
        case article
    }
    
    public enum ActionType: String, Codable {
        case view, share
    }
    
    public let id: Int
    public let recordType: RecordType
    public let actionType: ActionType
    public let objectId: Int
}
