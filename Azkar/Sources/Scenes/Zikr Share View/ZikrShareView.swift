import SwiftUI
import Library

struct ZikrShareView: View {

    let viewModel: ZikrViewModel
    var includeTitle = true
    var includeTranslation = true
    var includeTransliteration =  false
    var includeBenefits = true
    var includeLogo = true
    var includeSource = false
    var backgroundColor = Color.background
    var arabicTextAlignment = TextAlignment.trailing
    var otherTextAlignment = TextAlignment.leading
    var useFullScreen: Bool

    @Environment(\.colorScheme)
    var colorScheme

    var body: some View {
        ScrollView {
            content
                .frame(minHeight: useFullScreen ? UIScreen.main.bounds.height : 100)
                .background(useFullScreen ? backgroundColor : Color.clear)
        }
        .edgesIgnoringSafeArea(.all)
        .environment(\.dynamicTypeSize, .large)
        .onAppear {
            AnalyticsReporter.reportScreen("Zikr Share", className: viewName)
        }
    }

    var content: some View {
        VStack(spacing: 16) {
            if includeTitle, viewModel.zikr.title != nil {
                titleView
            }

            VStack(spacing: 0) {
                textView

                if includeTranslation, viewModel.translation.isEmpty == false {
                    Divider()

                    translationView
                }

                if includeTransliteration, viewModel.transliteration.isEmpty == false {
                    Divider()

                    transliterationView
                }

                if includeBenefits, let text = viewModel.zikr.benefits {
                    Divider()

                    benefitsView(text)
                }

                if includeSource {
                    sourceView
                }
            }
            .background(Color.contentBackground)
            .cornerRadius(Constants.cornerRadius)
            .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.1), radius: 5, x: 0, y: 1)

            if includeLogo {
                logoView
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 30)
    }
    
    private var titleView: some View {
        Text(viewModel.title)
    }
    
    private var textView: some View {
        Text(.init(viewModel.text.joined(separator: "\n")))
            .font(Font.customFont(viewModel.preferences.preferredArabicFont, style: .title1, sizeCategory: .large))
            .frame(maxWidth: .infinity, alignment: .trailing)
            .multilineTextAlignment(arabicTextAlignment)
            .padding()
    }
    
    private var translationView: some View {
        Text(viewModel.translation.joined(separator: "\n"))
            .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .body, sizeCategory: .large))
            .multilineTextAlignment(otherTextAlignment)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var transliterationView: some View {
        Text(viewModel.transliteration.joined(separator: "\n"))
            .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .body, sizeCategory: .large))
            .multilineTextAlignment(.leading)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func benefitsView(_ text: String) -> some View {
        ZikrBenefitsView(text: text)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var sourceView: some View {
        Text(viewModel.source)
            .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .caption1, sizeCategory: .large))
            .foregroundColor(Color.secondaryText)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var logoView: some View {
        VStack {
            if let image = UIImage(named: "ink") {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(6)
            }
            Text(L10n.Share.sharedWithAzkar)
                .foregroundColor(Color.secondary)
                .font(Font.system(size: 12, weight: .regular, design: .rounded).smallCaps())
        }
        .opacity(0.5)
        .background(backgroundColor)
    }

}

struct ZikrShareView_Previews: PreviewProvider {
    static var previews: some View {
        ZikrShareView(
            viewModel: ZikrViewModel(
                zikr: Zikr.placeholder(),
                isNested: true,
                hadith: Hadith.placeholder,
                preferences: Preferences.shared,
                player: Player.test
            ),
            useFullScreen: true
        )
        .previewLayout(.fixed(width: 380, height: 1200))
        .environment(\.locale, Locale(identifier: "ru_RU"))
        .environment(\.colorScheme, .dark)
    }
}
