import SwiftUI

public struct RectangularToggleStyle: ToggleStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Button {
                configuration.isOn.toggle()
            } label: {
                ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                    Rectangle()
                        .fill(configuration.isOn ? Color.accentColor : Color.gray)
                        .frame(width: 45, height: 30)
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .padding(5)
                }
                .animation(.smooth, value: configuration.isOn)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

private struct ApplyRectangularToggleStyle: ViewModifier {
    @Environment(\.appTheme) var appTheme
    
    func body(content: Content) -> some View {
        if appTheme.cornerRadius == 0 {
            content.toggleStyle(.rectangular)
        } else {
            content.toggleStyle(SwitchToggleStyle(tint: Color.accent))
        }
    }
}

extension View {
    public func applyThemedToggleStyle() -> some View {
        modifier(ApplyRectangularToggleStyle())
    }
}

extension ToggleStyle where Self == RectangularToggleStyle {
    public static var rectangular: RectangularToggleStyle {
        RectangularToggleStyle()
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var isOn = true
    Toggle("Toggle", isOn: $isOn)
        .toggleStyle(RectangularToggleStyle())
        .padding()
}
