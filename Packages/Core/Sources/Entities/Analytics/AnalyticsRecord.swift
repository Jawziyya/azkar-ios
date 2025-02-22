import Foundation

public struct AnalyticsRecord: Decodable {
    public enum RecordType: String, Codable {
        case article, ad
    }
    
    public enum ActionType: String, Codable {
        case impression, view, share, open, hide
    }
    
    public let id: Int
    public let recordType: RecordType
    public let actionType: ActionType
    public let objectId: Int
}
