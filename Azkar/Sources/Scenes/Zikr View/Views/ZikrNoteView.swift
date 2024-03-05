import SwiftUI
import Library

struct ZikrNoteView: View {
    
    let text: String
    let font: TranslationFont
    @Environment(\.highlightPattern)
    var pattern: String?
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "lightbulb")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundColor(Color.accent)
            Text(attributedString(text, highlighting: pattern))
                .font(Font.customFont(font, style: .footnote))
        }
        .padding()
    }
    
}

#Preview {
    ZikrNoteView(text: "Test", font: .courier)
        .environment(\.highlightPattern, "est")
}
