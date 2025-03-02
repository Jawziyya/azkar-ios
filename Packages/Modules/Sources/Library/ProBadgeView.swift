import SwiftUI

public struct ProBadgeView: View {
    
    public init() {}
    
    public var body: some View {
        Image(systemName: "lock.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 13, height: 13)
            .opacity(0.75)
            .foregroundStyle(Color.blue)
    }
    
}

#Preview {
    ProBadgeView()
}
