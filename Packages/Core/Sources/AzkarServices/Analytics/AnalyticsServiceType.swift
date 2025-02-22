import Foundation
import Entities

public protocol AnalyticsServiceType {
    
    func sendAnalyticsEvent(
        objectId: Int,
        recordType: AnalyticsRecord.RecordType,
        actionType: AnalyticsRecord.ActionType
    )
    
}
