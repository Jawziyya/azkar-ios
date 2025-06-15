import SwiftUI
import AzkarResources

/// A shape representing the illuminated portion of the Moon for a given lunar phase.
public struct LunarPhaseShape: Shape {
    /// Illuminated fraction, normalized from -1 (new moon) to 1 (full moon).
    public var progress: CGFloat
    /// True if waxing (light side on right), false if waning (light side on left).
    public var isWaxing: Bool

    public var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    public func path(in rect: CGRect) -> Path {
        let d = min(rect.width, rect.height)
        let r = d / 2
        let p = progress
        let c = (p * p - 1) / (2 * p)

        var path = Path()

        // choose the half‐ellipse
        let start = isWaxing ? Angle(degrees: 90)  : Angle(degrees: -90)
        let end   = isWaxing ? Angle(degrees: 270) : Angle(degrees: -270)
        path.addArc(
            center: CGPoint(x: r, y: r),
            radius: r,
            startAngle: start,
            endAngle: end,
            clockwise: false
        )

        guard p != 0 else {
            path.closeSubpath()
            return path
        }

        // inner arc
        let angle = atan2(1, abs(c))
        let center2 = CGPoint(x: (c + 1) * r, y: r)
        let radius2 = (p - c) * r
        path.addArc(
            center: center2,
            radius: radius2,
            startAngle: .radians(Double(angle)),
            endAngle: .radians(Double(2 * .pi - angle)),
            clockwise: true
        )

        return path
    }
    
    /// Normalizes illuminated fraction for lunar phase shape rendering.
    /// - Parameters:
    ///   - illuminatedFraction: The illuminated fraction (0.0 = new, 1.0 = full).
    ///   - isWaxing: Whether the phase is waxing.
    /// - Returns: A value from -1 to 1 for shape rendering.
    static func normalizeProgress(_ illuminatedFraction: Double, isWaxing: Bool) -> Double {
        if isWaxing {
            return 1 - 2 * illuminatedFraction
        } else {
            return 2 * illuminatedFraction - 1
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var isWaxing = true
    @Previewable @State var progress: CGFloat = 0.0
    
    VStack(spacing: 20) {
        ZStack {
            Circle()
                .fill(Color.yellow)
            LunarPhaseShape(progress: progress, isWaxing: isWaxing)
                .fill(Color.black.opacity(0.9))
        }
        .frame(width: 200, height: 200)

        Slider(value: $progress, in: -1...1)
            .padding(.horizontal)
        Toggle("Waxing", isOn: $isWaxing)

        Text("Progress: \(String(format: "%.2f", progress))")
            .font(.headline)
    }
    .padding()
}
