import SwiftUI

public struct CheckboxView: View {

    @Binding var isCheked: Bool
    
    public init(isCheked: Binding<Bool>) {
        _isCheked = isCheked
    }

    public var body: some View {
        Image(systemName: isCheked ? "checkmark.circle.fill" : "circle")
            .resizable()
            .scaledToFit()
            .foregroundColor(isCheked ? Color.accent : Color.gray)
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
