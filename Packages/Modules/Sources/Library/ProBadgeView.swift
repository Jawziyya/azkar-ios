import SwiftUI

public struct ProBadgeView: View {
    
    public init() {}
    
    public var body: some View {
        Image("lock")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 15, height: 15)
            .opacity(0.75)
    }
    
}

#Preview {
    ProBadgeView()
}
