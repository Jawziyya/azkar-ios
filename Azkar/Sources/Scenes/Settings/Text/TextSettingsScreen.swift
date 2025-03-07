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
            VStack {
                content
            }
            .applyContainerStyle()
        }
        .applyThemedToggleStyle()
        .customScrollContentBackground()
        .background(.background, ignoreSafeArea: .all)
        .navigationTitle(L10n.Settings.Text.title)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    var content: some View {
        Group {
            PickerMenu(
                title: L10n.Settings.Text.AdhkarCollectionsSource.title,
                selection: $viewModel.preferences.zikrCollectionSource,
                items: ZikrCollectionSource.allCases,
                itemTitle: { item in
                    item.shortTitle ?? item.title
                }
            )
            .pickerStyle(.menu)
            
            Divider()
            
            if viewModel.canChangeLanguage {
                PickerMenu(
                    title: L10n.Settings.Text.language,
                    selection: $viewModel.preferences.contentLanguage,
                    items: viewModel.getAvailableLanguages(),
                    itemTitle: \.title
                )
                .pickerStyle(.menu)
                
                Divider()
            }
            
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
            
            Divider()

            NavigationLink {
                ExtraTextSettingsScreen(viewModel: viewModel)
            } label: {
                NavigationLabel(title: L10n.Settings.Text.extra)
            }
        }
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
