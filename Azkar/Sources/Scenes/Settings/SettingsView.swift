//
//  SettingsView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 04.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

enum SettingsSection: Equatable {
    case root, themes, arabicFonts, fonts, icons
}

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}

struct SettingsView: View {

    @ObservedObject var viewModel: SettingsViewModel
    @State private var showFunFeaturesDescription = false
    @State private var showSystemFontsizeTip = false

    var body: some View {
        Form {
            Group {
                appearanceSection
                textSettingsSection
                notificationsSection
            }
            .listRowBackground(Color.contentBackground)
        }
        .accentColor(Color.accent)
        .toggleStyle(SwitchToggleStyle(tint: Color.accent))
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Appearance
    var appearanceSection: some View {
        Section {
            PickerView(label: L10n.Settings.Theme.title, titleDisplayMode: .inline, subtitle: viewModel.themeTitle, destination: themePicker)

            if viewModel.canChangeIcon {
                PickerView(label: L10n.Settings.Icon.title, titleDisplayMode: .inline, subtitle: viewModel.preferences.appIcon.title, destination: iconPicker)
            }

            Toggle(isOn: $viewModel.preferences.enableFunFeatures) {
                HStack {
                    Text(L10n.Settings.useFunFeatures)
                        .font(Font.system(.body, design: .rounded))
                    Spacer()
                    Button { } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color.accent.opacity(0.75))
                    }
                    .onTapGesture {
                        self.showFunFeaturesDescription = true
                    }
                    .alert(isPresented: $showFunFeaturesDescription) {
                        Alert(
                            title: Text(L10n.Settings.useFunFeaturesTip),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }

    var arabicFontPicker: some View {
        ItemPickerView(
            selection: $viewModel.preferences.arabicFont,
            items: ArabicFont.allCases
        )
    }
    
    var fontsPicker: some View {
        FontsView(viewModel: viewModel.fontsViewModel)
    }

    var themePicker: some View {
        ColorSchemesView(viewModel: viewModel.colorSchemeViewModel)
    }

    var iconPicker: some View {
        AppIconPackListView(viewModel: viewModel.appIconPackListViewModel)
    }

    // MARK: - Notifications
    var notificationsSection: some View {
        Section(header: Text(L10n.Settings.Notifications.title).font(Font.system(.caption, design: .rounded))) {
            Toggle(isOn: $viewModel.preferences.enableNotifications, label: {
                Text(L10n.Settings.Notifications.switchLabel)
                    .padding(.vertical, 8)
                    .font(Font.system(.body, design: .rounded))
            })

            if viewModel.preferences.enableNotifications {
                PickerView(label: L10n.Settings.Notifications.morningOptionLabel, titleDisplayMode: .inline, subtitle: viewModel.morningTime, destination: morningTimePicker)

                PickerView(label: L10n.Settings.Notifications.eveningOptionLabel, titleDisplayMode: .inline, subtitle: viewModel.eveningTime, destination: eveningTimePicker)
            }
        }
    }

    var morningTimePicker: some View {
        ItemPickerView(
            selection: $viewModel.morningTime,
            items: viewModel.morningDateItems,
            dismissOnSelect: true
        )
    }

    var eveningTimePicker: some View {
        ItemPickerView(
            selection: $viewModel.eveningTime,
            items: viewModel.eveningDateItems,
            dismissOnSelect: true
        )
    }

    // MARK: - Content Size
    var textSettingsSection: some View {
        Section(header: Text(L10n.Settings.Text.title).font(Font.system(.caption, design: .rounded))) {
            
            PickerView(
                label: L10n.Settings.Text.arabicTextFont,
                titleDisplayMode: .inline,
                subtitle: viewModel.preferences.arabicFont.title,
                destination: arabicFontPicker
            )
            
            NavigationLink {
                fontsPicker
            } label: {
                HStack {
                    Text(L10n.Settings.Text.translationTextFont)
                        .font(Font.system(.body, design: .rounded))
                        .foregroundColor(Color.text)
                    Spacer()
                    Text(viewModel.preferences.preferredFont.name)
                        .multilineTextAlignment(.trailing)
                        .font(Font.system(.body, design: .rounded))
                        .foregroundColor(Color.secondary)
                }
            }

            Toggle(isOn: $viewModel.preferences.showTashkeel) {
                Text(L10n.Settings.Text.showTashkeel)
                    .padding(.vertical, 8)
                    .font(Font.system(.body, design: .rounded))
            }
            
            Toggle(isOn: $viewModel.preferences.useSystemFontSize) {
                HStack {
                    Text(L10n.Settings.Text.useSystemFontSize)
                        .font(Font.system(.body, design: .rounded))
                    Spacer()
                    Button { } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color.accent.opacity(0.75))
                    }
                    .onTapGesture {
                        self.showSystemFontsizeTip = true
                    }
                    .alert(isPresented: $showSystemFontsizeTip) {
                        Alert(
                            title: Text(L10n.Settings.Text.useSystemFontSizeTip),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                .padding(.vertical, 8)
            }

            if viewModel.preferences.useSystemFontSize == false {
                self.sizePicker
            }
        }
    }
    
    var sizePicker: some View {
        Picker(
            selection: $viewModel.preferences.sizeCategory,
            label: Text(L10n.Settings.Text.fontSize)
                .font(Font.system(.body, design: .rounded))
                .padding(.vertical, 8)
        )
        {
            ForEach(ContentSizeCategory.availableCases, id: \.title) { size in
                Text(size.name)
                    .font(Font.system(.body, design: .rounded))
                    .environment(\.sizeCategory, size)
                    .tag(size)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }

}

private struct PickerView<T: View>: View {

    var label: String
    var navigationTitle: String?
    var titleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
    var subtitle: String
    var destination: T

    var body: some View {
        NavigationLink(
            destination: destination.navigationBarTitle(navigationTitle ?? label, displayMode: titleDisplayMode)
            )
        {
            HStack(spacing: 8) {
                Text(label)
                    .font(Font.system(.body, design: .rounded))
                    .foregroundColor(Color.text)
                Spacer()
                Text(subtitle)
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(.body, design: .rounded))
                    .foregroundColor(Color.secondary)
            }
            .padding(.vertical, 10)
            .buttonStyle(PlainButtonStyle())
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            viewModel: SettingsViewModel(preferences: Preferences())
        )
        .embedInNavigation()
    }
}
