import SwiftUI

public struct StandardToggleStyle: ToggleStyle {
    let showProBadge: Bool
    let tint: Color
    
    public init(showProBadge: Bool = false, tint: Color = .accentColor) {
        self.showProBadge = showProBadge
        self.tint = tint
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Button {
                configuration.isOn.toggle()
            } label: {
                ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                    Capsule()
                        .fill(configuration.isOn ? tint : Color.gray.opacity(0.3))
                        .frame(width: 51, height: 31)
                    
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 1)
                        .frame(width: 27, height: 27)
                        .padding(2)
                        .overlay(alignment: .center) {
                            if showProBadge {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.accent)
                                    .padding(2)
                            }
                        }
                }
                .animation(.smooth, value: configuration.isOn)
            }
        }
        .hapticFeedback(.impact(flexibility: .soft), trigger: configuration.isOn)
    }
}

extension ToggleStyle where Self == StandardToggleStyle {
    public static var standard: StandardToggleStyle {
        StandardToggleStyle()
    }
    
    public static func standard(showProBadge: Bool = false, tint: Color = .accentColor) -> StandardToggleStyle {
        StandardToggleStyle(showProBadge: showProBadge, tint: tint)
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var isOn = true
    VStack {
        Toggle("Standard Toggle", isOn: $isOn)
            .toggleStyle(StandardToggleStyle())
            .padding()
        
        Toggle("Pro Feature Toggle", isOn: $isOn)
            .toggleStyle(StandardToggleStyle(showProBadge: true))
            .padding()
            
        Toggle("Custom Tint Toggle", isOn: $isOn)
            .toggleStyle(StandardToggleStyle(tint: .purple))
            .padding()
    }
}
