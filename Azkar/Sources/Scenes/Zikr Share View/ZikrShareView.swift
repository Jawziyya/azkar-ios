// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI

struct ZikrShareView: View {

    let viewModel: ZikrViewModel
    var includeTranslation = true
    var includeTransliteration =  false
    var includeBenefits = true
    var includeLogo = true

    var body: some View {
        ScrollView {
            content
        }
        .edgesIgnoringSafeArea(.all)
    }

    var content: some View {
        VStack(spacing: 16) {
            Text(viewModel.title)

            VStack(spacing: 0) {
                Text(.init(viewModel.text))
                    .font(Font.customFont(viewModel.preferences.preferredArabicFont, style: .title1, sizeCategory: .large))
                    .multilineTextAlignment(.trailing)
                    .padding()

                if includeTranslation, let text = viewModel.translation {
                    Divider()

                    Text(.init(text))
                        .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .body, sizeCategory: .large))
                        .multilineTextAlignment(.leading)
                        .padding()
                }

                if includeTransliteration, let text = viewModel.transliteration {
                    Divider()

                    Text(.init(text))
                        .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .body, sizeCategory: .large))
                        .multilineTextAlignment(.leading)
                        .padding()
                }

                if includeBenefits, let text = viewModel.zikr.benefit {
                    Divider()

                    HStack(alignment: .top, spacing: 8) {
                        Text("💎")
                            .minimumScaleFactor(0.1)
                            .font(Font.largeTitle)
                            .frame(maxWidth: 20, maxHeight: 15)
                        Text(text)
                            .font(.customFont(viewModel.preferences.preferredTranslationFont, style: .footnote))
                    }
                    .padding()
                }
            }
            .background(Color.contentBackground)
            .cornerRadius(Constants.cornerRadius)

            if includeLogo {
                VStack {
                    Image(uiImage: UIImage(named: "ic_ink.png")!)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .cornerRadius(6)
                    Text(L10n.Share.sharedWithAzkar)
                        .foregroundColor(Color.secondary)
                        .font(Font.system(size: 12, weight: .regular, design: .rounded).smallCaps())
                }
                .opacity(0.5)
            }
        }
        .padding()
        .background(Color.background)
    }

}

struct ZikrShareView_Previews: PreviewProvider {
    static var previews: some View {
        ZikrShareView(
            viewModel: ZikrViewModel(
                zikr: Zikr.data[3],
                preferences: Preferences.shared,
                player: Player.test
            )
        )
        .previewLayout(.fixed(width: 380, height: 1200))
        .environment(\.locale, Locale(identifier: "ru_RU"))
    }
}
