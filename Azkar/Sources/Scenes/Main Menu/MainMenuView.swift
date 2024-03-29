import SwiftUI
import AudioPlayer
import UserNotifications
import Entities
import ArticleReader

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
            if viewModel.searchQuery.isEmpty == false {
                SearchResultsView(
                    viewModel: viewModel.searchViewModel,
                    onSelect: viewModel.naviateToSearchResult(_:)
                )
            } else {
                SearchSuggestionsView(
                    viewModel: viewModel.searchSuggestionsViewModel
                )
            }
        } else {
            content
        }
    }
    
    var content: some View {
        List {
            menuContent
                .listRowSeparator(.hidden)
                .listRowBackground(itemsBackgroundColor)
        }
        .customListSectionSpacing(.compact)
        .listStyle(.insetGrouped)
        .customScrollContentBackground()
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

    @ViewBuilder
    private var menuContent: some View {
        dayNightAzkar

        otherAzkar

        if viewModel.articles.isEmpty == false {
            articlesView
                .listRowInsets(.zero)
                .frame(height: articleCellHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.accentColor.opacity(0.5), lineWidth: 3)
                )
        }
        
        appSections
        
        additionalItems
        
        if let fadl = viewModel.fadl {
            fadlSection(fadl)
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
                })
                .buttonStyle(.plain)
            }
        }
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
            .listRowBackground(Color.clear)
            .listRowInsets(.zero)
        }
        .frame(maxWidth: .infinity)
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
        Section {
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
    }
    
    // MARK: - App Sections
    private var appSections: some View {
        Section {
            ForEach(viewModel.infoModels) { item in
                getMenuItem(
                    item: item,
                    action: {
                        viewModel.navigateToMenuItem(item)
                    }
                )
            }
        }
    }
    
    // MARK: - Additional Sections
    private var additionalItems: some View {
        Section {
            ForEach(viewModel.additionalMenuItems) { item in
                getMenuItem(
                    item: item,
                    action: {
                        item.action?()
                    }
                )
                .disabled(item.action == nil)
            }
        }
    }
    
    private func fadlSection(_ fadl: Fadl) -> some View {
        Section {
            VStack(spacing: 8) {
                Text(fadl.text)
                    .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .caption1))
                    .tracking(1.2)
                    .foregroundColor(Color.text.opacity(0.7))
                
                Text(fadl.source)
                    .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .caption2))
                    .foregroundColor(Color.secondaryText.opacity(0.5))
            }
            .listRowBackground(Color.clear)
            .frame(maxWidth: .infinity)
        }
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
