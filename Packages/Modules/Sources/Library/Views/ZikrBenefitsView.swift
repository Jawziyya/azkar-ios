import SwiftUI

public struct ZikrBenefitsView: View {
    
    public let text: String
    public let font: AppFont
    
    public init(text: String, font: AppFont) {
        self.text = text
        self.font = font
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image("gem-stone")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 20, maxHeight: 15)
            Text(text)
                .font(.custom(font.postscriptName, size: 12, relativeTo: .footnote))
        }
        .padding()
    }
    
}

#Preview {
    ZikrBenefitsView(text: """
    #Preview {
        ZikrBenefitsView(text: "")
    }
    """, font: TranslationFont.iowanOldStyle)
}
