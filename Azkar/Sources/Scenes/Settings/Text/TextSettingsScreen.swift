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
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .navigationTitle(L10n.Settings.Text.title)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    var content: some View {
        Group {
            genericPicker(
                title: L10n.Settings.Text.AdhkarCollectionsSource.title,
                binding: $viewModel.preferences.zikrCollectionSource,
                items: ZikrCollectionSource.allCases,
                itemTitle: { item in
                    item.shortTitle ?? item.title
                }
            )
            .pickerStyle(.menu)
            
            Divider()
            
            if viewModel.canChangeLanguage {
                genericPicker(
                    title: L10n.Settings.Text.language,
                    binding: $viewModel.preferences.contentLanguage,
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
                NavigationLabel(title: "Advanced Settings")
            }
        }
    }
    
    func genericPicker<T: Identifiable & Hashable>(
        title: String,
        binding: Binding<T>,
        items: [T],
        itemTitle: @escaping (T) -> String
    ) -> some View {
        Menu {
            ForEach(items, id: \.self) { item in
                Button {
                    binding.wrappedValue = item
                } label: {
                    Text(itemTitle(item))
                        .systemFont(.callout)
                    if binding.wrappedValue == item {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.accent)
                    }
                }
            }
        } label: {
            HStack {
                Text(title)
                    .systemFont(.body)
                    .foregroundStyle(Color.text)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(itemTitle(binding.wrappedValue))
                    .systemFont(.callout)
                    .foregroundStyle(Color.secondaryText)
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.secondaryText)
            }
            .padding(.vertical, 8)
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
