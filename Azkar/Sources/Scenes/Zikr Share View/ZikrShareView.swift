// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI
import NukeUI
import Nuke

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
    var selectedBackground: ZikrShareBackgroundItem

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.appTheme) var appTheme
    @State private var dynamicColorScheme: ColorScheme?

    // New computed property to check if background is an image
    private var isBackgroundImage: Bool {
        switch selectedBackground.backgroundType {
        case .solidColor:
            return false
        case .patternImage, .remoteImage:
            return true
        }
    }
    
    var body: some View {
        ScrollView {
            content
                .frame(minHeight: useFullScreen ? UIScreen.main.bounds.height : 100)
                .background(backgroundForContent)
        }
        .edgesIgnoringSafeArea(.all)
        .environment(\.dynamicTypeSize, .large)
        .environment(\.colorScheme, customColorScheme)
        .onAppear {
            AnalyticsReporter.reportScreen("Zikr Share", className: viewName)
        }
        .onChange(of: selectedBackground) { _ in
            dynamicColorScheme = nil
        }
    }
    
    var customColorScheme: ColorScheme {
        dynamicColorScheme ?? colorScheme
    }
    
    var backgroundForContent: some View {
        Group {
            switch selectedBackground.backgroundType {
            case .solidColor(let color):
                color
            case .patternImage(let image):
                renderImage(image)
            case .remoteImage(let url):
                if useFullScreen, let cachedImage = getCachedImage(for: url) {
                    renderImage(cachedImage)
                } else {
                    LazyImage(url: url) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .onAppear {
                                    if let color = state.imageContainer?.image.dominantColor() {
                                        dynamicColorScheme = isDarkColor(color) ? .dark : .light
                                    }
                                }
                        } else {
                            ZStack {
                                if state.isLoading {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
        }
        .id(selectedBackground)
    }
    
    // New method to render image with common logic
    private func renderImage(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .onAppear {
                if let color = image.dominantColor() {
                    dynamicColorScheme = isDarkColor(color) ? .dark : .light
                }
            }
    }
    
    // New method to check for cached images
    private func getCachedImage(for url: URL) -> UIImage? {
        let request = ImageRequest(url: url)
        let cachedContainer = ImagePipeline.shared.cache.cachedImage(for: request)
        return cachedContainer?.image
    }

    // Helper function to determine if a color is dark
    private func isDarkColor(_ color: UIColor) -> Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Calculate luminance (perceived brightness)
        // Using the formula: 0.299*R + 0.587*G + 0.114*B
        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        
        // If luminance is less than 0.5, it's considered a dark color
        return luminance < 0.5
    }

    var content: some View {
        VStack(spacing: 16) {
            if includeTitle, let title = viewModel.title {
                Text(title)
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
                        Image("gem-stone")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 20, maxHeight: 15)
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
            .background {
                if isBackgroundImage {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    Color.contentBackground
                }
            }
            .cornerRadius(appTheme.cornerRadius)
            .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.1), radius: 5, x: 0, y: 1)

            if includeLogo {
                VStack {
                    if let image = UIImage(named: "ink-icon") {
                        Image(uiImage: image)
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(6)
                    }
                    Text(L10n.Share.sharedWithAzkar)
                        .font(Font.system(size: 12, weight: .regular, design: .rounded).smallCaps())
                }
                .foregroundStyle(Color.text)
                .opacity(0.5)
            }
        }
        .padding(.horizontal, 20)
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
            useFullScreen: true,
            selectedBackground: .defaultBackground
        )
        .previewLayout(.fixed(width: 380, height: 1200))
        .environment(\.locale, Locale(identifier: "ru_RU"))
        .environment(\.colorScheme, .dark)
    }
}
