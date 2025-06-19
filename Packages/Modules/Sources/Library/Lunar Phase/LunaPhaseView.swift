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
            if info.illuminatedFraction >= 0.9 {
                getPhaseImage(.newMoon)
                    .opacity(0.5)
                
                getPhaseImage(.fullMoon)
                    .clipShape(
                        LunarPhaseShape(
                            progress: normalizedFraction,
                            isWaxing: !info.isWaxing
                        )
                    )
            } else if info.illuminatedFraction <= 0.1 {
                // Nearly new: use new moon image
                getPhaseImage(.newMoon)
            } else {
                getPhaseImage(.newMoon)
                    .opacity(0.25)
                
                getPhaseImage(info.phase)
            }
        }
    }
    
    /// The new moon visual representation.
    private func getPhaseImage(_ phase: LunarPhase) -> some View {
        Image("moon-phase/\(phase.imageName)", bundle: azkarResourcesBundle)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
}
