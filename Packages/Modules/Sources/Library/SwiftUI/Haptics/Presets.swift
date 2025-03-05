#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

// MARK: - Indicating start and stop

extension HapticFeedback {
    /// Indicates that an activity started.
    ///
    /// Use this haptic when starting a timer or any other activity that can be explicitly started and stopped.
    ///
    /// Only plays feedback on watchOS.
    static public var start: HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_START") {
            #if os(watchOS)
            WKInterfaceDevice.current().play(.start)
            #endif
        }
    }
    
    /// Indicates that an activity stopped.
    ///
    /// Use this haptic when stopping a timer or other activity that was previously started.
    ///
    /// Only plays feedback on watchOS.
    static public var stop: HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_STOP") {
            #if os(watchOS)
            WKInterfaceDevice.current().play(.stop)
            #endif
        }
    }
}

// MARK: - Indicating changes and selections

extension HapticFeedback {
    /// Indicates the alignment of a dragged item.
    ///
    /// For example, use this pattern in a drawing app when the user drags a shape into alignment with another shape.
    ///
    /// Only plays feedback on macOS.
    static public var alignment: HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_ALIGNMENT") {
            #if os(macOS)
            NSHapticFeedbackManager.defaultPerformer
                .perform(.alignment, performanceTime: .default)
            #endif
        }
    }
    
    
    /// Indicates that an important value decreased below a significant threshold.
    ///
    /// Only plays feedback on watchOS.
    static public var decrease: HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_DECREASE") {
            #if os(watchOS)
            WKInterfaceDevice.current().play(.directionDown)
            #endif
        }
    }
    
    /// Indicates that an important value increased above a significant threshold.
    ///
    /// Only plays feedback on watchOS.
    static public var increase: HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_INCREASE") {
            #if os(watchOS)
            WKInterfaceDevice.current().play(.directionUp)
            #endif
        }
    }
    
    /// Indicates movement between discrete levels of pressure.
    ///
    /// For example, as the user presses a fast-forward button on a video player, playback could increase or decrease and haptic feedback could be provided as different levels of pressure are reached.
    ///
    /// Only plays feedback on macOS.
    static public var levelChange: HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_LEVELCHANGE") {
            #if os(macOS)
            NSHapticFeedbackManager.defaultPerformer
                .perform(.levelChange, performanceTime: .default)
            #endif
        }
    }
    
    /// Indicates that a UI element’s values are changing.
    ///
    /// Only plays feedback on iOS and watchOS.
    static public var selection: HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_SELECTION") {
            #if os(iOS)
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
            #elseif os(watchOS)
            WKInterfaceDevice.current().play(.click)
            #endif
        }
    }
}

// MARK: - Indicating the outcome of an operation

extension HapticFeedback {
    /// Indicates that a task or action has completed.
    ///
    /// Only plays feedback on iOS and watchOS.
    static public var success: HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_SUCCESS") {
            #if os(iOS)
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
            #elseif os(watchOS)
            WKInterfaceDevice.current().play(.success)
            #endif
        }
    }
    
    ///
    ///
    /// Only plays feedback on iOS and watchOS.
    static public var warning: HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_WARNING") {
            #if os(iOS)
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.warning)
            #elseif os(watchOS)
            WKInterfaceDevice.current().play(.retry)
            #endif
        }
    }
    
    /// Indicates that an error has occurred.
    ///
    /// Only plays feedback on iOS and watchOS.
    static public var error: HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_ERROR") {
            #if os(iOS)
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.error)
            #elseif os(watchOS)
            WKInterfaceDevice.current().play(.failure)
            #endif
        }
    }
}

// MARK: - Producing a physical impact

extension HapticFeedback {
    /// Provides a physical metaphor you can use to complement a visual experience.
    ///
    /// Use this to provide feedback for UI elements colliding. It should supplement the user experience, since only some platforms will play feedback in response to it.
    ///
    /// Only plays feedback on iOS and watchOS.
    static public var impact: HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_IMPACT") {
            #if os(iOS)
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
            #elseif os(watchOS)
            WKInterfaceDevice.current().play(.click)
            #endif
        }
    }
    
    /// Provides a physical metaphor you can use to complement a visual experience.
    ///
    /// Use this to provide feedback for UI elements colliding. It should supplement the user experience, since only some platforms will play feedback in response to it.
    ///
    /// Not all platforms will play different feedback for different weights and intensities of impact.
    ///
    /// Only plays feedback on iOS and watchOS.
    static public func impact(
        weight: HapticFeedback.Weight,
        intensity: Double = 1.0
    ) -> HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_IMPACT_\(weight.rawValue)_\(intensity)") {
            #if os(iOS)
            let style: UIImpactFeedbackGenerator.FeedbackStyle = switch weight {
            case .light: .light
            case .medium: .medium
            case .heavy: .heavy
            }
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)
            #elseif os(watchOS)
            WKInterfaceDevice.current().play(.click)
            #endif
        }
    }
    
    /// Provides a physical metaphor you can use to complement a visual experience.
    ///
    /// Use this to provide feedback for UI elements colliding. It should supplement the user experience, since only some platforms will play feedback in response to it.
    ///
    /// Not all platforms will play different feedback for different flexibilities and intensities of impact.
    ///
    /// Only plays feedback on iOS and watchOS.
    static public func impact(
        flexibility: HapticFeedback.Flexibility,
        intensity: Double = 1.0
    ) -> HapticFeedback {
        HapticFeedback("SwiftUI_Haptics_TYPE_IMPACT_\(flexibility.rawValue)_\(intensity)") {
            #if os(iOS)
            let style: UIImpactFeedbackGenerator.FeedbackStyle = switch flexibility {
            case .rigid: .rigid
            case .solid: .medium
            case .soft: .soft
            }
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred(intensity: intensity)
            #elseif os(watchOS)
            WKInterfaceDevice.current().play(.click)
            #endif
        }
    }
}
