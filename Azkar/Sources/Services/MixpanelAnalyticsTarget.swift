import Mixpanel
import AzkarServices

final class MixpanelAnalyticsTarget: AnalyticsTarget {
    
    static let shared = MixpanelAnalyticsTarget()
    
    private init() {}
    
    func reportEvent(name: String, metadata: [String: Any]?) {
        let properties: [String: MixpanelType] = metadata?.compactMapValues { value in
            return value as? MixpanelType
        } ?? [:]
        Mixpanel.mainInstance().track(
            event: name,
            properties: properties
        )
    }
    
    func reportScreen(screenName: String, className: String?) {
        #if MIXPANEL_REPORT_SCREEN_VIEW
        Mixpanel.mainInstance().track(
            event: "screen_view",
            properties: ["screen_name": screenName, "class_name": className as MixpanelType]
        )
        #endif
    }
    
    func setUserAttribute(_ type: UserAttributeType, value: String) {
        Mixpanel.mainInstance().people.set(property: type.rawValue, to: value)
    }
    
}
