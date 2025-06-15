import Foundation
import TinyMoon

/// Model representing the current phase and illumination of the Moon.
public struct LunarPhaseInfo: Identifiable, Hashable {
    /// The current lunar phase (e.g., new moon, full moon, etc.).
    public let phase: LunarPhase
    /// Phase of the Moon, represented as a fraction (0.0 = new, 0.5 = full, 0.99 = nearly full).
    public let fraction: Double
    /// Indicates whether the Moon is waxing (growing) or waning (shrinking).
    public let isWaxing: Bool
    /// Illuminated portion of the Moon, where 0.0 = new and 0.99 = full.
    public let illuminatedFraction: Double
    /// Emoji representation of the current lunar phase.
    public let emoji: String
    /// Unique identifier for the phase.
    public var id: String {
        phase.rawValue
    }
}

extension LunarPhaseInfo {
    /// Initializes a `LunarPhaseInfo` from a given date.
    /// - Parameter date: The date for which to calculate the lunar phase.
    public init(_ date: Date) {
        let moon = TinyMoon.calculateExactMoonPhase(date)
        let phase = LunarPhase(rawValue: moon.moonPhase.rawValue) ?? .fullMoon
        self.phase = phase
        self.fraction = moon.phaseFraction
        self.isWaxing = phase.isWaxing
        self.illuminatedFraction = moon.illuminatedFraction
        self.emoji = moon.emoji
    }
}

/// Enum representing all possible lunar phases.
public enum LunarPhase: String, CaseIterable, Hashable {
    case newMoon = "New Moon"
    case waxingCrescent = "Waxing Crescent"
    case firstQuarter = "First Quarter"
    case waxingGibbous = "Waxing Gibbous"
    case fullMoon = "Full Moon"
    case waningGibbous = "Waning Gibbous"
    case lastQuarter = "Last Quarter"
    case waningCrescent = "Waning Crescent"
    
    /// Returns true if the phase is waxing (growing).
    var isWaxing: Bool {
        switch self {
        case .newMoon, .waxingCrescent, .firstQuarter, .waxingGibbous:
            return true
        case .fullMoon, .waningGibbous, .lastQuarter, .waningCrescent:
            return false
        }
    }
    
    /// Returns the Russian title for the phase.
    var titleRu: String {
        switch self {
        case .newMoon: return "Новолуние"
        case .waxingCrescent: return "Молодая Луна"
        case .firstQuarter: return "Первая четверть"
        case .waxingGibbous: return "Растущая Луна"
        case .fullMoon: return "Полнолуние"
        case .waningGibbous: return "Убывающая Луна"
        case .lastQuarter: return "Последняя четверть"
        case .waningCrescent: return "Старая Луна"
        }
    }

    /// Returns the asset image name for the phase.
    var imageName: String {
        switch self {
        case .newMoon: return "new-moon"
        case .waxingCrescent: return "waxing-crescent"
        case .firstQuarter: return "first-quarter"
        case .waxingGibbous: return "waxing-gibbous"
        case .fullMoon: return "full-moon"
        case .waningGibbous: return "waning-gibbous"
        case .lastQuarter: return "last-quarter"
        case .waningCrescent: return "waning-crescent"
        }
    }

    /// Returns the current lunar phase for today.
    static var current: LunarPhase {
        LunarPhaseInfo(Date()).phase
    }
}
