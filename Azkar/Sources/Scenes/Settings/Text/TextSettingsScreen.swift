// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI
import Popovers
import Entities
import Library

extension ZikrCollectionSource: PickableItem {}

struct TextSettingsScreen: View {
    
    @ObservedObject var viewModel: TextSettingsViewModel
    @Environment(\.colorTheme) var colorTheme

    var body: some View {
        ScrollView {
            VStack {
                content
            }
            .applyContainerStyle()
        }
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

            Toggle(isOn: .init(get: {
                return viewModel.selectedArabicFontSupportsVowels ? viewModel.preferences.showTashkeel : false
            }, set: { newValue in
                viewModel.preferences.showTashkeel = newValue
            })) {
                Text(L10n.Settings.Text.showTashkeel)
                    .padding(.vertical, 8)
                    .systemFont(.body)
            }
            .disabled(!viewModel.selectedArabicFontSupportsVowels)
            
            Divider()

            Toggle(isOn: $viewModel.preferences.enableLineBreaks) {
                HStack {
                    Text(L10n.Settings.Breaks.title)
                        .systemFont(.body)
                    Spacer()
                    Templates.Menu {
                        Text(L10n.Settings.Breaks.info)
                            .padding()
                            .cornerRadius(10)
                    } label: { _ in
                        Image(systemName: "info.circle")
                            .foregroundStyle(Color.accent.opacity(0.75))
                    }
                }
                .padding(.vertical, 8)
            }
            
            Divider()
            
            Toggle(isOn: $viewModel.preferences.useSystemFontSize) {
                HStack {
                    Text(L10n.Settings.Text.useSystemFontSize)
                        .systemFont(.body)
                    Spacer()
                    Templates.Menu {
                        Text(L10n.Settings.Text.useSystemFontSizeTip)
                            .padding()
                            .cornerRadius(10)
                    } label: { _ in
                        Image(systemName: "info.circle")
                            .foregroundStyle(Color.accent.opacity(0.75))
                    }
                }
                .padding(.vertical, 8)
            }
            
            Divider()

            if viewModel.preferences.useSystemFontSize == false {
                self.sizePicker
                Divider()
            }
            
            lineSpacingView
            
            Divider()
            
            textDisplayModePicker
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
    
    private func createNavigationPickerLabel(
        label: String,
        value: String?
    ) -> some View {
        HStack {
            Text(label)
                .systemFont(.body)
                .foregroundStyle(Color.text)
            Spacer()
            if let value {
                Text(value)
                    .multilineTextAlignment(.trailing)
                    .systemFont(.body)
                    .foregroundStyle(Color.secondary)
            }
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.secondaryText)
        }
        .padding(.vertical, 8)
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
    
    var sizePicker: some View {
        Picker(
            selection: $viewModel.preferences.sizeCategory,
            label: Text(L10n.Settings.Text.fontSize)
                .systemFont(.body)
                .padding(.vertical, 8)
        ) {
            ForEach(ContentSizeCategory.availableCases, id: \.title) { size in
                Text(size.name)
                    .systemFont(.body)
                    .environment(\.sizeCategory, size)
                    .tag(size)
            }
        }
        .pickerStyle(.segmented)
        .padding(.vertical, 8)
    }
    
    var lineSpacingView: some View {
        NavigationLink {
            List {
                Group {
                    Section(L10n.Settings.Text.arabicLineSpacing) {
                        lineSpacingPicker
                    }
                    Section(L10n.Settings.Text.translationLineSpacing) {
                        translationLineSpacingPicker
                    }
                }
                .listRowBackground(Color.contentBackground)
            }
            .customScrollContentBackground()
            .navigationBarTitle(L10n.Settings.Text.lineSpacing)
            .background(Color.background, ignoresSafeAreaEdges: .all)
        } label: {
            createNavigationPickerLabel(
                label: L10n.Settings.Text.lineSpacing,
                value: ""
            )
        }
    }

    var lineSpacingPicker: some View {
        Picker(
            selection: $viewModel.preferences.lineSpacing,
            label: EmptyView()
        ) {
            ForEach(LineSpacing.allCases) { height in
                Text(height.title)
                    .systemFont(.body)
                    .tag(height)
            }
        }
        .pickerStyle(.segmented)
    }

    var translationLineSpacingPicker: some View {
        Picker(
            selection: $viewModel.preferences.translationLineSpacing,
            label: EmptyView()
        ) {
            ForEach(LineSpacing.allCases) { height in
                Text(height.title)
                    .systemFont(.body)
                    .tag(height)
            }
        }
        .pickerStyle(.segmented)
    }
    
    var textDisplayModePicker: some View {
        NavigationLink {
            ZikrReadingModeSelectionScreen(
                zikr: viewModel.readingModeSampleZikr ?? Zikr.placeholder(),
                mode: $viewModel.preferences.zikrReadingMode,
                player: .test
            )
            .navigationTitle(L10n.Settings.Text.ReadingMode.title)
        } label: {
            NavigationLabel(title: L10n.Settings.Text.ReadingMode.title)
        }
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
