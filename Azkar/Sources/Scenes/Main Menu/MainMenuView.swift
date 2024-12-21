import SwiftUI
import AudioPlayer
import UserNotifications
import Entities
import ArticleReader
import Library

private extension View {
    func applyMenuPadding() -> some View {
        self.padding(.horizontal, 20)
    }
}

struct MainMenuView: View {

    @ObservedObject var viewModel: MainMenuViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.colorTheme) var colorTheme
    @Environment(\.isSearching) var isSearching
    @Environment(\.dismissSearch) var dismissSearch
    @State private var showAd = true
    
    private let articleCellHeight: CGFloat = 230
    private let borderWidth: CGFloat = 2
    private var borderColor: Color {
        Color.accentColor.opacity(0.5)
    }

    var body: some View {
        displayContent
            .textInputAutocapitalization(.never)
            .attachEnvironmentOverrides(viewModel: EnvironmentOverridesViewModel(preferences: viewModel.preferences))
            .onAppear {
                AnalyticsReporter.reportScreen("Main Menu", className: viewName)
            }
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            Constants.windowSafeAreaInsets = proxy.safeAreaInsets
                        }
                }
            )
    }
    
    @ViewBuilder
    var displayContent: some View {
        if isSearching {
            searchView
        } else {
            content
        }
    }
    
    var content: some View {
        ScrollView {
            VStack(spacing: 20) {
                menuContent
            }
            .padding(.vertical, 20)
        }
        .customScrollContentBackground()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.navigateToSettings) {
                    Image(systemName: "gear")
                }
            }
        }
        .background(
            Color.background
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    ZStack {
                        if viewModel.enableEidBackground {
                            Image("eid_background")
                                .resizable()
                                .aspectRatio(contentMode: ContentMode.fill)
                                .edgesIgnoringSafeArea(.all)
                                .blendMode(.overlay)
                        }
                    }
                )
        )
    }
    
    @ViewBuilder private var searchView: some View {
        if viewModel.searchQuery.isEmpty {
            SearchSuggestionsView(
                viewModel: viewModel.searchSuggestionsViewModel,
                onSearchSuggestionSelection: { query in
                    viewModel.searchQuery = query
                }
            )
        } else {
            SearchResultsView(
                viewModel: viewModel.searchViewModel,
                onSelect: viewModel.naviateToSearchResult(_:)
            )
        }
    }

    @ViewBuilder
    private var menuContent: some View {
        dayNightAzkar

        otherAzkar

        if viewModel.articles.isEmpty == false {
            articlesView
        }
        
        if let ad = viewModel.ad {
            adView(ad)
        }
    }
    
    // MARK: - Day & Night Azkar
    private var dayNightAzkar: some View {
        Section {
            HStack(spacing: 8) {
                getMainMenuSectionView(.morning)
                
                Spacer()
                
                getMainMenuSectionView(.evening)
            }
        }
        .frame(maxWidth: .infinity)
        .applyMenuPadding()
    }
    
    private func getMainMenuSectionView(_ category: ZikrCategory) -> some View {
        getMenuButton {
            MainMenuLargeGroup(category: category)
                .frame(maxWidth: .infinity)
                .removeSaturationIfNeeded()
                .background(Color.contentBackground)
                .applyTheme()
        } action: {
            self.viewModel.navigateToCategory(category)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
    }
    
    // MARK: - Other Azkar
    private var otherAzkar: some View {
        VStack {
            if let dua = viewModel.additionalAdhkar {
                ForEach(dua) { item in
                    getMenuItem(
                        item: item,
                        action: {
                            viewModel.navigateToZikr(item.zikr)
                        }
                    )
                }
            }

            ForEachIndexed(viewModel.otherAzkarModels) { _, position, item in
                getMenuItem(
                    item: item,
                    action: {
                        viewModel.navigateToCategory(item.category)
                    }
                )
                
                if position != .last {
                    Divider()
                }
            }
        }
        .padding()
        .removeSaturationIfNeeded()
        .background(Color.contentBackground)
        .applyTheme()
        .applyMenuPadding()
    }
    
    private func getMenuItem(
        item: AzkarMenuType,
        flipContents: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        getMenuButton(label: {
            HStack {
                MainMenuSmallGroup(item: item, flip: flipContents)
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.tertiaryText)
            }
        }, action: action)
    }
    
    private func getMenuButton<V: View>(
        label: () -> V,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action, label: {
            label().contentShape(Rectangle())
        })
        .buttonStyle(.plain)
    }

    private var articlesView: some View {
        TabView {
            ForEach(viewModel.articles) { article in
                Button(action: {
                    viewModel.navigateToArticle(article)
                }, label: {
                    ArticleCellView(
                        article: article,
                        imageMaxHeight: articleCellHeight
                    )
                    .applyTheme()
                    .padding(.horizontal, 20)
                })
                .buttonStyle(.plain)
            }
        }
        .frame(height: articleCellHeight + 3)
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .removeSaturationIfNeeded()
    }
    
    func adView(_ ad: Ad) -> some View {
        Group {
            if colorTheme == .flat || colorTheme == .reader {
                adButton(ad).applyTheme()
            } else {
                adButton(ad)
                    .clipShape(RoundedRectangle(cornerRadius: colorTheme.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: colorTheme.cornerRadius)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
            }
        }
        .applyMenuPadding()
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        ))
    }
    
    func adButton(_ ad: Ad) -> some View {
        AdButton(
            item: AdButtonItem(ad: ad),
            cornerRadius: colorTheme.cornerRadius,
            onClose: {
                withAnimation(.spring) {
                    viewModel.hideAd(ad)
                }
            },
            action: {
                viewModel.handleAdSelection(ad)
            }
        )
        .onAppear {
            viewModel.sendAdImpressionEvent(ad)
        }
        .frame(maxWidth: .infinity)
    }
    
}

#Preview("Menu Default") {
    Preferences.shared.colorTheme = .default
    return MainMenuView(
        viewModel: MainMenuViewModel.placeholder
    )
}

#Preview("Menu Ink") {
    Preferences.shared.colorTheme = .ink
    return MainMenuView(
        viewModel: MainMenuViewModel.placeholder
    )
}

#Preview("Menu Sea") {
    Preferences.shared.colorTheme = .sea
    return MainMenuView(
        viewModel: MainMenuViewModel.placeholder
    )
}

#Preview("Menu Purple Rose") {
    Preferences.shared.colorTheme = .purpleRose
    return MainMenuView(
        viewModel: MainMenuViewModel.placeholder
    )
}

#Preview("Menu Rose Quartz") {
    Preferences.shared.colorTheme = .roseQuartz
    return MainMenuView(
        viewModel: MainMenuViewModel.placeholder
    )
}
