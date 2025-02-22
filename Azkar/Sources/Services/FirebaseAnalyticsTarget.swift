import FirebaseAnalytics
import AzkarServices

final class FirebaseAnalyticsTarget: AnalyticsTarget {
    
    static let shared = FirebaseAnalyticsTarget()
    
    private init() {}
    
    func reportEvent(name: String, metadata: [String: Any]?) {
        Analytics.logEvent(name, parameters: metadata)
    }
    
    func reportScreen(screenName: String, className: String?) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: className as Any
        ])
    }
    
    func setUserAttribute(_ type: UserAttributeType, value: String) {
        Analytics.setUserProperty(value, forName: type.rawValue)
    }
    
}
