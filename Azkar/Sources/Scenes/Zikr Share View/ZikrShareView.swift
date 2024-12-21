// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI

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

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.colorTheme) var colorTheme

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
            if includeTitle {
                Text(viewModel.title)
            }

            VStack(spacing: 0) {
                Text(.init(viewModel.text.joined(separator: "\n")))
                    .font(Font.customFont(viewModel.preferences.preferredArabicFont, style: .title1, sizeCategory: .large))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .multilineTextAlignment(arabicTextAlignment)
                    .padding()

                if includeTranslation {
                    Divider()

                    Text(viewModel.translation.joined(separator: "\n"))
                        .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .body, sizeCategory: .large))
                        .multilineTextAlignment(otherTextAlignment)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if includeTransliteration {
                    Divider()

                    Text(viewModel.transliteration.joined(separator: "\n"))
                        .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .body, sizeCategory: .large))
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if includeBenefits, let text = viewModel.zikr.benefits {
                    Divider()

                    HStack(alignment: .top, spacing: 8) {
                        Text("💎")
                            .minimumScaleFactor(0.1)
                            .font(Font.largeTitle)
                            .frame(maxWidth: 20, maxHeight: 15)
                            .grayscale(1)
                        Text(text)
                            .font(.customFont(viewModel.preferences.preferredTranslationFont, style: .footnote))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                if includeSource {
                    Text(viewModel.source)
                        .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .caption1, sizeCategory: .large))
                        .foregroundStyle(Color.secondaryText)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background(Color.contentBackground)
            .cornerRadius(colorTheme.cornerRadius)
            .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.1), radius: 5, x: 0, y: 1)

            if includeLogo {
                VStack {
                    if let image = UIImage(named: "ink") {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(6)
                    }
                    Text(L10n.Share.sharedWithAzkar)
                        .foregroundStyle(Color.secondary)
                        .font(Font.system(size: 12, weight: .regular, design: .rounded).smallCaps())
                }
                .opacity(0.5)
                .background(backgroundColor)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 30)
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
