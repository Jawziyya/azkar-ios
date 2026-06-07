import Foundation
import FactoryKit
import Entities
import Library

struct SoundPickerInfo: Hashable {
    let sound: ReminderSound
    let type: ReminderSoundPickerViewModel.ReminderType
}

enum SettingsDestination: Hashable {
    case notificationsList
    case appearance
    case text
    case counter
    case reminders
    case soundPicker(SoundPickerInfo)
    case aboutApp
}

struct SettingsSheet: Identifiable {
    enum Destination {
        case zikrCollectionsOnboarding(preselectedCollection: ZikrCollectionSource)
    }

    let id = UUID()
    let destination: Destination
}

@MainActor
protocol SettingsNavigationRouting: AnyObject {
    func show(_ destination: SettingsDestination)
    func presentSubscription(sourceScreen: String, completion: (() -> Void)?)
    func presentZikrCollectionsOnboarding()
}

extension SettingsNavigationRouting {
    func presentSubscription(sourceScreen: String) {
        presentSubscription(sourceScreen: sourceScreen, completion: nil)
    }
}

@MainActor
final class EmptySettingsNavigator: SettingsNavigationRouting {
    func show(_ destination: SettingsDestination) {}
    func presentSubscription(sourceScreen: String, completion: (() -> Void)?) {}
    func presentZikrCollectionsOnboarding() {}
}

@MainActor
final class SettingsNavigator: ObservableObject, SettingsNavigationRouting {

    @Published var stack: [SettingsDestination] = []
    @Published var sheet: SettingsSheet?

    @Injected(\.preferences) private var preferences: Preferences
    @Injected(\.subscriptionManager) private var subscriptionManager: SubscriptionManagerType
    @Injected(\.localAnalytics) private var analytics: AppAnalyticsTracking

    init(initialDestination: SettingsDestination? = nil) {
        if let initialDestination {
            stack = [initialDestination]
        }
    }

    func show(_ destination: SettingsDestination) {
        analytics.settings.openedDetail(destination.analyticsName)
        stack.append(destination)
    }

    func presentSubscription(sourceScreen: String, completion: (() -> Void)?) {
        subscriptionManager.presentPaywall(
            presentationType: .screen(sourceScreen),
            completion: completion
        )
    }

    func presentZikrCollectionsOnboarding() {
        sheet = .init(destination: .zikrCollectionsOnboarding(
            preselectedCollection: preferences.zikrCollectionSource
        ))
    }
}

extension SettingsDestination {

    var analyticsName: AppAnalyticsSettingsDestination {
        switch self {
        case .notificationsList:
            return .notificationsList
        case .appearance:
            return .appearance
        case .text:
            return .text
        case .counter:
            return .counter
        case .reminders:
            return .reminders
        case .soundPicker:
            return .soundPicker
        case .aboutApp:
            return .aboutApp
        }
    }

}
