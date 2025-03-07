import SwiftUI

struct SearchResultsItemView: View {
    
    let result: SearchResultZikr
    
    var body: some View {
        HStack(alignment: .top) {
            content
            Spacer()
            Text(result.language.id)
                .textCase(.uppercase)
                .font(Font.system(size: 12, design: .monospaced))
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(Color.secondaryBackground)
                .foregroundStyle(Color.secondaryText)
                .cornerRadius(3)
        }
    }
    
    var content: some View {
        VStack(spacing: 10) {
            if let title = result.title {
                Text(getText(title))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if let text = result.text {
                Text(getText(text))
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            if let translation = result.translation {
                Text(getText(translation))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if let caption = result.caption {
                Text(getText(caption))
                    .systemFont(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if let caption2 = result.caption2 {
                Text(getText(caption2))
                    .systemFont(.caption2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if let footnote = result.footnote {
                Text(getText(footnote))
                    .systemFont(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .systemFont(.body)
        .foregroundStyle(Color.text)
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.leading)
    }
    
    private func getText(
        _ text: String
    ) -> AttributedString {
        var attributedString = AttributedString(text)
        var currentSearchRange = attributedString.startIndex..<attributedString.endIndex

        while let range = attributedString[currentSearchRange].range(of: result.highlightText, options: [.caseInsensitive, .diacriticInsensitive]) {
            let globalRange = range.lowerBound..<range.upperBound
            attributedString[globalRange].underlineStyle = .single
            attributedString[globalRange].underlineColor = UIColor(Color.accent)
            
            if globalRange.upperBound < attributedString.endIndex {
                currentSearchRange = globalRange.upperBound..<attributedString.endIndex
            } else {
                break
            }
        }

        return attributedString
    }
    
}

@available(iOS 17, *)
#Preview("Search Results Item View", traits: .fixedLayout(width: 300, height: 300)) {
    SearchResultsItemView(
        result: SearchResultZikr(
            zikr: .placeholder(),
            query: "Title"
        )
    )
}
