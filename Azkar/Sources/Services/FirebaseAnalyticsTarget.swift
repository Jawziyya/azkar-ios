import FirebaseAnalytics
import Library

final class FirebaseAnalyticsTarget: AnalyticsTarget {
    
    static let shared = FirebaseAnalyticsTarget()
    
    private init() {}
    
    func reportEvent(name: String, metadata: [String: Any]?) {
        Analytics.logEvent(name, parameters: metadata)
    }
    
    func setUserAttribute(_ type: UserAttributeType, value: String) {
        Analytics.setUserProperty(value, forName: type.rawValue)
    }
    
}
