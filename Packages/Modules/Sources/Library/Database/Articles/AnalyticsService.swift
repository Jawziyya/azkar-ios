import Foundation
import Supabase
import Entities

public struct AnalyticsService {
    
    private let supabaseClient: SupabaseClient
    
    public init(
        supabaseClient: SupabaseClient
    ) {
        self.supabaseClient = supabaseClient
    }
    
    public func sendAnalyticsEvent(
        objectId: Int,
        recordType: AnalyticsRecord.RecordType,
        actionType: AnalyticsRecord.ActionType
    ) {
        Task {
            do {
                try await supabaseClient
                    .from("analytics")
                    .insert(AnalyticsEvent(
                        objectId: objectId,
                        recordType: recordType,
                        actionType: actionType
                    ))
                    .execute()
                    .value
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
