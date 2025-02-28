import SwiftUI

public struct ProBadgeView: View {
    
    public init() {}
    
    public var body: some View {
        Image(systemName: "lock")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .foregroundStyle(Color.blue)
    }
    
}

#Preview {
    ProBadgeView()
}
