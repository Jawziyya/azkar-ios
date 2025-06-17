import SwiftUI
import AzkarResources

public struct ZikrBenefitsView: View {
    
    public let text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image("gem-stone", bundle: azkarResourcesBundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 15, maxHeight: 15)
            Text(text)
        }
        .padding()
    }
    
}

#Preview {
    ZikrBenefitsView(text: """
    #Preview {
        ZikrBenefitsView(text: "")
    }
    """
    )
}
