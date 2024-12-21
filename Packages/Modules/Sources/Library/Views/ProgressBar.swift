import SwiftUI

public struct ProgressBar: View {
    
    private let value: Double
    private let maxValue: Double
    private let backgroundEnabled: Bool
    private let backgroundColor: Color
    private let foregroundStyle: Color
    
    public init(
        value: Double,
        maxValue: Double,
        backgroundEnabled: Bool = true,
        backgroundColor: Color = Color.gray,
        foregroundStyle: Color = Color.black
    ) {
        self.value = value
        self.maxValue = maxValue
        self.backgroundEnabled = backgroundEnabled
        self.backgroundColor = backgroundColor
        self.foregroundStyle = foregroundStyle
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { geometryReader in
                if self.backgroundEnabled {
                    Capsule()
                        .foregroundStyle(self.backgroundColor)
                }
                
                Capsule()
                    .frame(width: geometryReader.size.width * (value / maxValue))
                    .foregroundStyle(self.foregroundStyle)
                    .animation(.easeIn, value: value)
            }
        }
    }
    
}
