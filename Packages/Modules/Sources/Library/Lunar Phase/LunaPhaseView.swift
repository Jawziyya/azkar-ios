import SwiftUI
import AzkarResources

/// A SwiftUI view that visually represents the current phase of the Moon.
///
/// Use `LunarPhaseView` to display a stylized lunar phase illustration based on a `LunarPhaseInfo` model.
/// The view automatically renders the correct appearance for new moon, waxing, waning, and full moon phases.
public struct LunarPhaseView: View {
    /// Information describing the current lunar phase and illumination.
    public let info: LunarPhaseInfo
    
    /// Creates a new lunar phase view.
    /// - Parameter info: The lunar phase information to display.
    public init(info: LunarPhaseInfo) {
        self.info = info
    }
    
    public var body: some View {
        let normalizedFraction = LunarPhaseShape.normalizeProgress(info.illuminatedFraction, isWaxing: info.isWaxing)
        ZStack {
            switch info.phase {
            case .newMoon:
                newMoon
            default:
                illuminatedMoon(
                    normalizedFraction: normalizedFraction,
                    isWaxing: info.isWaxing
                )
            }
        }
    }
    
    /// The new moon visual representation.
    private var newMoon: some View {
        Image("moon-phase/new-moon", bundle: azkarResourcesBundle)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 2)
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
    }
    
    /// The illuminated moon visual representation for all phases except new moon.
    /// - Parameters:
    ///   - normalizedFraction: The normalized illuminated fraction (0...1).
    ///   - isWaxing: Whether the moon is waxing (true) or waning (false).
    /// - Returns: A view representing the illuminated portion of the moon.
    private func illuminatedMoon(
        normalizedFraction: Double,
        isWaxing: Bool
    ) -> some View {
        ZStack {
            Image("moon-phase/new-moon", bundle: azkarResourcesBundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(color: .black.opacity(0.18), radius: 5, x: 0, y: 2)
            
            Image("moon-phase/full-moon", bundle: azkarResourcesBundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(
                    LunarPhaseShape(
                        progress: normalizedFraction,
                        isWaxing: !isWaxing
                    )
                )
                .shadow(color: .yellow.opacity(0.12), radius: 8, x: 0, y: 0)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        }
    }
}
