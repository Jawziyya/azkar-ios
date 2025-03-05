import SwiftUI

public struct CheckboxView: View {

    @Binding var isCheked: Bool
    @Environment(\.appTheme) var appTheme
    
    public init(isCheked: Binding<Bool>) {
        _isCheked = isCheked
    }

    public var body: some View {
        if isCheked {
            Image(systemName: "checkmark")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.white)
                .padding(6)
                .background {
                    shapeBackground
                }
        } else {
            shapeBackground
        }
    }
    
    private var shapeBackground: some View {
        Group {
            if appTheme.cornerRadius > 0 {
                Circle()
                    .strokeBorder(isCheked ? Color.accent : Color.gray, lineWidth: 1.5)
                    .background(isCheked ? Circle().fill(Color.accent) : nil)
            } else {
                Rectangle()
                    .strokeBorder(isCheked ? Color.accent : Color.gray, lineWidth: 1.5)
                    .background(isCheked ? Rectangle().fill(Color.accent) : nil)
            }
        }
        .foregroundStyle(isCheked ? Color.accent : Color.gray)
    }
}

struct CheckboxView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CheckboxView(isCheked: .constant(true))
            CheckboxView(isCheked: .constant(false))
        }
        .previewLayout(.fixed(width: 20, height: 20))
    }
}
