// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI
import Popovers
import Entities

struct TextSettingsScreen: View {
    
    @ObservedObject var viewModel: TextSettingsViewModel

    var body: some View {
        List {
            content
                .listRowBackground(Color.contentBackground)
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
            if viewModel.canChangeLanguage {
                if #available(iOS 16.5, *) {
                    languagePicker(
                        title: L10n.Settings.Text.language,
                        binding: $viewModel.preferences.contentLanguage
                    )
                    .pickerStyle(.menu)
                } else {
                    PickerView(
                        label: L10n.Settings.Text.language,
                        subtitle: viewModel.preferences.contentLanguage.title,
                        destination: contentLanguagePicker
                    )
                }
            }
            
            NavigationLink {
                arabicFontsPicker
            } label: {
                createNavigationPickerLabel(
                    label: L10n.Settings.Text.arabicTextFont,
                    value: viewModel.preferences.preferredArabicFont.name
                )
            }
            
            NavigationLink {
                translationFontsPicker
            } label: {
                createNavigationPickerLabel(
                    label: L10n.Settings.Text.translationTextFont,
                    value: viewModel.preferences.preferredTranslationFont.name
                )
            }

            Toggle(isOn: .init(get: {
                return viewModel.selectedArabicFontSupportsVowels ? viewModel.preferences.showTashkeel : false
            }, set: { newValue in
                viewModel.preferences.showTashkeel = newValue
            })) {
                Text(L10n.Settings.Text.showTashkeel)
                    .padding(.vertical, 8)
                    .font(Font.system(.body, design: .rounded))
            }
            .disabled(!viewModel.selectedArabicFontSupportsVowels)

            Toggle(isOn: $viewModel.preferences.enableLineBreaks) {
                HStack {
                    Text(L10n.Settings.Breaks.title)
                        .font(Font.system(.body, design: .rounded))
                    Spacer()
                    Templates.Menu {
                        Text(L10n.Settings.Breaks.info)
                            .padding()
                            .cornerRadius(10)
                    } label: { _ in
                        Image(systemName: "info.circle")
                            .foregroundColor(Color.accent.opacity(0.75))
                    }
                }
                .padding(.vertical, 8)
            }
            
            Toggle(isOn: $viewModel.preferences.useSystemFontSize) {
                HStack {
                    Text(L10n.Settings.Text.useSystemFontSize)
                        .font(Font.system(.body, design: .rounded))
                    Spacer()
                    Templates.Menu {
                        Text(L10n.Settings.Text.useSystemFontSizeTip)
                            .padding()
                            .cornerRadius(10)
                    } label: { _ in
                        Image(systemName: "info.circle")
                            .foregroundColor(Color.accent.opacity(0.75))
                    }
                }
                .padding(.vertical, 8)
            }

            if viewModel.preferences.useSystemFontSize == false {
                self.sizePicker
            }
            
            lineSpacingView
            
            textDisplayModePicker
        }
    }
    
    func languagePicker(
        title: String,
        binding: Binding<Language>
    ) -> some View {
        Picker(
            selection: binding,
            label: Text(title)
                .font(Font.system(.body, design: .rounded))
                .padding(.vertical, 8)
        ) {
            ForEach(viewModel.getAvailableLanguages()) { lang in
                Text(lang.title)
                    .font(Font.system(.body, design: .rounded))
                    .id(lang.id)
                    .tag(lang)
            }
        }
    }
    
    private func createNavigationPickerLabel(
        label: String,
        value: String?
    ) -> some View {
        HStack {
            Text(label)
                .font(Font.system(.body, design: .rounded))
                .foregroundColor(Color.text)
            Spacer()
            if let value {
                Text(value)
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(.body, design: .rounded))
                    .foregroundColor(Color.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    var arabicFontsPicker: some View {
        FontsView(viewModel: viewModel.getFontsViewModel(fontsType: .arabic))
    }
    
    var translationFontsPicker: some View {
        FontsView(viewModel: viewModel.getFontsViewModel(fontsType: .translation))
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
                .font(Font.system(.body, design: .rounded))
                .padding(.vertical, 8)
        ) {
            ForEach(ContentSizeCategory.availableCases, id: \.title) { size in
                Text(size.name)
                    .font(Font.system(.body, design: .rounded))
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
                    .font(Font.system(.body, design: .rounded))
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
                    .font(Font.system(.body, design: .rounded))
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
            Text(L10n.Settings.Text.ReadingMode.title)
                .padding(.vertical, 8)
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
