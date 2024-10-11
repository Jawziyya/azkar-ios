import Entities

public struct ArticlesAnalyticsEvent: Encodable {
    public let actionType: AnalyticsRecord.ActionType
    public let objectId: Int
    public let recordType: String
    
    public init(
        actionType: AnalyticsRecord.ActionType,
        objectId: Int,
        recordType: String
    ) {
        self.actionType = actionType
        self.objectId = objectId
        self.recordType = recordType
    }
}
