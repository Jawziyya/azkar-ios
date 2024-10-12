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
    @Environment(\.isSearching) var isSearching
    @Environment(\.dismissSearch) var dismissSearch
    
    private let articleCellHeight: CGFloat = 230

    private var itemsBackgroundColor: SwiftUI.Color {
        Color.contentBackground
    }
    
    var body: some View {
        displayContent
            .textInputAutocapitalization(.never)
            .saturation(viewModel.preferences.colorTheme == .ink ? 0 : 1)
            .attachEnvironmentOverrides(viewModel: EnvironmentOverridesViewModel(preferences: viewModel.preferences))
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
                viewModel: viewModel.searchSuggestionsViewModel
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
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .stroke(Color.accentColor.opacity(0.5), lineWidth: 3)
                    )
                    .padding(.horizontal, 20)
                })
                .buttonStyle(.plain)
            }
        }
        .frame(height: articleCellHeight)
        .tabViewStyle(.page(indexDisplayMode: .automatic))
    }
    
    // MARK: - Day & Night Azkar
    private var dayNightAzkar: some View {
        Section {
            HStack(spacing: 8) {
                getMainMenuSectionView(MainMenuLargeGroupViewModel(
                    category: .morning,
                    title: L10n.Category.morning,
                    animationName: "sun",
                    animationSpeed: 0.5
                ))
                
                Spacer()
                
                getMainMenuSectionView(MainMenuLargeGroupViewModel(
                    category: .evening,
                    title: L10n.Category.evening,
                    animationName: colorScheme == .dark ? "moon" : "moon2",
                    animationSpeed: 0.5
                ))
            }
        }
        .frame(maxWidth: .infinity)
        .applyMenuPadding()
    }
    
    private func getMainMenuSectionView(_ item: MainMenuLargeGroupViewModel) -> some View {
        getMenuButton {
            MainMenuLargeGroup(viewModel: item)
                .frame(maxWidth: .infinity)
                .background(itemsBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        } action: {
            self.viewModel.navigateToCategory(item.category)
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

            ForEach(viewModel.otherAzkarModels) { item in
                getMenuItem(
                    item: item,
                    action: {
                        viewModel.navigateToCategory(item.category)
                    }
                )
            }
        }
        .padding()
        .background(Color.contentBackground)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
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
                    .foregroundColor(Color.tertiaryText)
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
