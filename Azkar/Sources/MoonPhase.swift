import Foundation
import TinyMoon

struct MoonPhaseInfo: Identifiable, Hashable {
    let phase: MoonPhase
    let emoji: String
    
    var id: String {
        phase.rawValue
    }
}

enum MoonPhase: String, CaseIterable, Hashable {
    case newMoon = "New Moon"
    case waxingCrescent = "Waxing Crescent"
    case firstQuarter = "First Quarter"
    case waxingGibbous = "Waxing Gibbous"
    case fullMoon = "Full Moon"
    case waningGibbous = "Waning Gibbous"
    case lastQuarter = "Last Quarter"
    case waningCrescent = "Waning Crescent"

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

    static var current: MoonPhase {
        getMoonPhase(for: Date()).phase
    }
}

func getMoonPhase(for date: Date) -> MoonPhaseInfo {
    let moon = TinyMoon.calculateExactMoonPhase(date)
    let phase = MoonPhase(rawValue: moon.moonPhase.rawValue) ?? .newMoon
    return MoonPhaseInfo(
        phase: phase,
        emoji: moon.emoji
    )
}
