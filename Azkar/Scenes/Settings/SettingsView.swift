//
//  SettingsView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 04.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}

struct SettingsView: View {

    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Form {
            self.appearanceSection
            self.fontsSection
            self.notificationsSection
        }
        .navigationTitle(Text("settings.title"))
        .toggleStyle(SwitchToggleStyle(tint: Color.accent))
        .background(Color.dimmedBackground.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Appearance
    var appearanceSection: some View {
        Section {
            PickerView(label: NSLocalizedString("settings.theme.title", comment: "Theme settings section title."), titleDisplayMode: .inline, subtitle: viewModel.preferences.theme.title, destination: themePicker)

            if viewModel.canChangeIcon {
                PickerView(label: NSLocalizedString("settings.icon.title", comment: "Icon settings section title."), titleDisplayMode: .inline, subtitle: viewModel.preferences.appIcon.title, destination: iconPicker)
            }
        }
    }

    var arabicFontPicker: some View {
        ItemPickerView(
            selection: $viewModel.preferences.arabicFont,
            items: ArabicFont.allCases
        )
    }

    var themePicker: some View {
        ItemPickerView(
            selection: $viewModel.preferences.theme,
            items: Theme.allCases,
            dismissOnSelect: false
        )
    }

    var iconPicker: some View {
        ItemPickerView(
            selection: $viewModel.preferences.appIcon,
            items: AppIcon.availableIcons
        )
    }

    // MARK: - Notifications
    var notificationsSection: some View {
        Section(header: Text("settings.notifications.title", comment: "Notifications screen title.")) {
            Toggle(isOn: $viewModel.preferences.enableNotifications, label: {
                Text("settings.notifications.switch-label", comment: "Notification turn on/off switch label.").padding(.vertical, 8)
            })

            if viewModel.preferences.enableNotifications {
                PickerView(label: NSLocalizedString("settings.notifications.morning-option-label", comment: "Morning notifications option picker title."), titleDisplayMode: .inline, subtitle: viewModel.morningTime, destination: morningTimePicker)

                PickerView(label: NSLocalizedString("settings.notifications.evening-option-label", comment: "Evening notification option picker title."), titleDisplayMode: .inline, subtitle: viewModel.eveningTime, destination: eveningTimePicker)
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
    var fontsSection: some View {
        Section(header: Text("settings.text.title", comment: "Text settings section header.")) {
            PickerView(label: NSLocalizedString("settings.text.arabic-text-font", comment: "Arabic font picker label."), titleDisplayMode: .inline, subtitle: viewModel.preferences.arabicFont.title, destination: arabicFontPicker)

            Toggle(isOn: $viewModel.preferences.useSystemFontSize, label: {
                Text("settings.text.use-system-font-size", comment: "Enable/disable system font size usage option label.").padding(.vertical, 8)
            })

            if viewModel.preferences.useSystemFontSize == false {
                self.sizePicker
            }
        }
    }

    var sizePicker: some View {
        Picker(selection: $viewModel.preferences.sizeCategory, label: Text("settings.text.font-size", comment: "Font size settings section.").padding(.vertical, 8)) {
            ForEach(ContentSizeCategory.availableCases, id: \.title) { size in
                Text(size.name)
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
                Spacer()
                Text(subtitle)
                    .multilineTextAlignment(.trailing)
                    .font(Font.body)
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
