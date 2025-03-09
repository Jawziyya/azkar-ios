// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI
import Popovers
import Entities
import Library

extension ZikrCollectionSource: PickableItem {}

struct TextSettingsScreen: View {
    
    @ObservedObject var viewModel: TextSettingsViewModel
    @Environment(\.appTheme) var appTheme

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Color.clear.frame(height: 20)
                
                collectionSection
                textContentSettings
                fonts
                extraSettings
            }
        }
        .applyThemedToggleStyle()
        .customScrollContentBackground()
        .background(.background, ignoreSafeArea: .all)
        .navigationTitle(L10n.Settings.Text.title)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    var collectionSection: some View {
        VStack(spacing: 0) {
            HeaderView(text: L10n.Settings.Text.AdhkarCollectionsSource.header)
            
            PickerMenu(
                title: L10n.Settings.Text.AdhkarCollectionsSource.title,
                selection: $viewModel.preferences.zikrCollectionSource,
                items: ZikrCollectionSource.allCases,
                itemTitle: { item in
                    item.shortTitle ?? item.title
                }
            )
            .pickerStyle(.menu)
            .applyContainerStyle()
            
            FooterView(
                text: viewModel.preferences.zikrCollectionSource == .azkarRU
                       ? L10n.AdhkarCollections.AzkarRu.description
                       : L10n.AdhkarCollections.Hisn.description
            )
        }
    }
    
    var textContentSettings: some View {
        VStack(spacing: 0) {
            HeaderView(text: L10n.Settings.Text.Content.header)
            
            VStack {
                PickerMenu(
                    title: L10n.Settings.Text.language,
                    selection: .init(get: {
                        viewModel.preferences.contentLanguage
                    }, set: viewModel.setContentLanguage),
                    items: viewModel.getAvailableLanguages(),
                    itemTitle: \.title
                )
                .pickerStyle(.menu)
                
                Divider()
                
                PickerMenu(
                    title: L10n.Settings.Text.transliteration,
                    selection: $viewModel.preferences.transliterationType,
                    items: viewModel.availableTransliterationTypes,
                    itemTitle: { $0.title ?? L10n.Common.default }
                )
                .pickerStyle(.menu)
            }
            .applyContainerStyle()
        }
    }
    
    var fonts: some View {
        VStack(spacing: 0) {
            HeaderView(text: L10n.Settings.Text.Fonts.header)
            
            VStack {
                NavigationLink {
                    arabicFontsPicker
                } label: {
                    NavigationLabel(
                        title: L10n.Settings.Text.arabicTextFont,
                        label: viewModel.preferences.preferredArabicFont.name
                    )
                }
                
                Divider()
                
                NavigationLink {
                    translationFontsPicker
                } label: {
                    NavigationLabel(
                        title: L10n.Settings.Text.translationTextFont,
                        label: viewModel.preferences.preferredTranslationFont.name
                    )
                }
            }
            .applyContainerStyle()
        }
    }
    
    var extraSettings: some View {
        NavigationLink {
            ExtraTextSettingsScreen(viewModel: viewModel)
        } label: {
            NavigationLabel(title: L10n.Settings.Text.extra)
        }
        .applyContainerStyle()
    }
    
    var arabicFontsPicker: some View {
        FontsView(viewModel: viewModel.getFontsViewModel(fontsType: .arabic))
    }
    
    var translationFontsPicker: some View {
        FontsView(viewModel: viewModel.getFontsViewModel(fontsType: .translation))
    }
    
    var adhkarSourcePicker: some View {
        ItemPickerView(
            selection: $viewModel.preferences.zikrCollectionSource,
            items: ZikrCollectionSource.allCases,
            dismissOnSelect: true
        )
    }
    
    var contentLanguagePicker: some View {
        ItemPickerView(
            selection: $viewModel.preferences.contentLanguage,
            items: viewModel.getAvailableLanguages(),
            dismissOnSelect: true
        )
    }
}

#Preview {
    NavigationView {
        TextSettingsScreen(
            viewModel: TextSettingsViewModel(
                router: .empty
            )
        )
    }
}
