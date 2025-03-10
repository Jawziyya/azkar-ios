// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI
import NukeUI
import Nuke
import Library

extension TextAlignment {
    var frameAlignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        case .center:
            return .center
        }
    }
}

struct ZikrShareView: View {

    let viewModel: ZikrViewModel
    let includeTitle: Bool
    let includeTranslation: Bool
    let includeTransliteration: Bool
    let includeBenefits: Bool
    let includeLogo: Bool
    let includeSource: Bool
    var arabicTextAlignment = TextAlignment.trailing
    var otherTextAlignment = TextAlignment.leading
    var nestIntoScrollView: Bool
    var useFullScreen: Bool
    var selectedBackground: ZikrShareBackgroundItem

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.appTheme) var appTheme
    @Environment(\.colorTheme) var colorTheme
    @State private var dynamicColorScheme: ColorScheme?

    // New computed property to check if background is an image
    private var isBackgroundImage: Bool {
        switch selectedBackground.backgroundType {
        case .solidColor:
            return false
        case .localImage, .remoteImage:
            return true
        }
    }
    
    var body: some View {
        container
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
    
    @ViewBuilder
    var container: some View {
        if nestIntoScrollView {
            ScrollView {
                content
            }
        } else {
            content
        }
    }
    
    var customColorScheme: ColorScheme {
        dynamicColorScheme ?? colorScheme
    }
    
    var backgroundForContent: some View {
        Group {
            switch selectedBackground.backgroundType {
            case .solidColor(let colorType):
                colorTheme.getColor(colorType)
            case .localImage(let image):
                renderImage(image)
            case .remoteImage(let item):
                if useFullScreen, let cachedImage = getCachedImage(for: item.originalURL) {
                    renderImage(cachedImage)
                } else {
                    LazyImage(url: item.originalURL) { state in
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
                    .customFont(.title1, isArabic: true)
                    .frame(maxWidth: .infinity, alignment: arabicTextAlignment.frameAlignment)
                    .multilineTextAlignment(arabicTextAlignment)
                    .padding()

                if includeTranslation {
                    Divider()

                    Text(viewModel.translation.joined(separator: "\n"))
                        .customFont(.body)
                        .multilineTextAlignment(otherTextAlignment)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: otherTextAlignment.frameAlignment)
                }

                if includeTransliteration, !viewModel.transliteration.isEmpty {
                    Divider()

                    Text(viewModel.transliteration.joined(separator: "\n"))
                        .customFont(.body)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: otherTextAlignment.frameAlignment)
                }

                if includeBenefits, let text = viewModel.zikr.benefits?.textOrNil {
                    Divider()
                    
                    ZikrBenefitsView(text: text)
                        .customFont(.footnote)
                        .frame(maxWidth: .infinity, alignment: otherTextAlignment.frameAlignment)
                }

                if includeSource, let source = viewModel.source.textOrNil {
                    Text(source)
                        .customFont(.caption1)
                        .frame(maxWidth: .infinity, alignment: otherTextAlignment.frameAlignment)
                        .foregroundStyle(.secondaryText)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                }
            }
            .background {
                if isBackgroundImage {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    colorTheme.getColor(.contentBackground)
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
                .foregroundStyle(.text)
                .opacity(0.5)
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 30)
        .frame(
            maxWidth: .infinity,
            minHeight: useFullScreen ? UIScreen.main.bounds.height : 100
        )
        .background(backgroundForContent)
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
            includeTitle: true,
            includeTranslation: true,
            includeTransliteration: true,
            includeBenefits: true,
            includeLogo: true,
            includeSource: true,
            nestIntoScrollView: false,
            useFullScreen: true,
            selectedBackground: .defaultBackground
        )
        .previewLayout(.fixed(width: 380, height: 1200))
        .environment(\.locale, Locale(identifier: "ru_RU"))
        .environment(\.colorScheme, .dark)
    }
}
