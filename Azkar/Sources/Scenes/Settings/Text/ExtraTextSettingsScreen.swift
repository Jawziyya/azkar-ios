// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI
import Popovers
import Entities
import Library

struct ExtraTextSettingsScreen: View {
    
    @ObservedObject var viewModel: TextSettingsViewModel
    @Environment(\.colorTheme) var colorTheme
    
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
    }
    
    var content: some View {
        Group {
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
                            .foregroundStyle(.accent, opacity: 0.75)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Divider()
            
            Toggle(isOn: $viewModel.preferences.useSystemFontSize.animation(.smooth)) {
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
                            .foregroundStyle(.accent, opacity: 0.75)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Divider()

            if viewModel.preferences.useSystemFontSize == false {
                sizePicker
                    .animation(.smooth, value: viewModel.preferences.useSystemFontSize)
                Divider()
            }
            
            lineSpacingView
            
            Divider()
            
            textDisplayModePicker
        }
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
                .listRowBackground(colorTheme.getColor(.contentBackground))
            }
            .customScrollContentBackground()
            .navigationBarTitle(L10n.Settings.Text.lineSpacing)
            .background(.background, ignoreSafeArea: .all)
        } label: {
            NavigationLabel(title: L10n.Settings.Text.lineSpacing)
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
        ExtraTextSettingsScreen(
            viewModel: TextSettingsViewModel(router: .empty)
        )
    }
}
