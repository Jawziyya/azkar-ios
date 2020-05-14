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
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(Text("Настройки"), displayMode: .inline)
    }

    // MARK: - Appearance
    var appearanceSection: some View {
        Section {
            PickerView(label: "Тема", subtitle: viewModel.preferences.theme.title, destination: themePicker)

            if viewModel.canChangeIcon {
                PickerView(label: "Значок приложения", subtitle: viewModel.preferences.appIcon.title, destination: iconPicker)
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
        Section(header: Text("Уведомления")) {
            Toggle(isOn: $viewModel.preferences.enableNotifications, label: {
                Text("Напоминать об утренних и вечерних азкарах")
            })

            if viewModel.preferences.enableNotifications {
                PickerView(label: "Напоминание об утренних азкарах", subtitle: viewModel.morningTime, destination: morningTimePicker)

                PickerView(label: "Напоминание о вечерних азкарах", subtitle: viewModel.eveningTime, destination: eveningTimePicker)
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
        Section(header: Text("Текст")) {
            PickerView(label: "Шрифт арабского языка", subtitle: viewModel.preferences.arabicFont.title, destination: arabicFontPicker)

            Toggle(isOn: $viewModel.preferences.useSystemFontSize, label: {
                Text("Системный размер текста")
            })

            if viewModel.preferences.useSystemFontSize == false {
                self.sizePicker
            }
        }
    }

    var sizePicker: some View {
        Picker("Размер текста", selection: $viewModel.preferences.sizeCategory) {
            ForEach(ContentSizeCategory.availableCases, id: \.title) { size in
                Text(size.title)
                    .environment(\.sizeCategory, size)
                    .tag(size)
            }
        }
        .pickerStyle(DefaultPickerStyle())
    }

}

private struct PickerView<T: View>: View {

    var label: String
    var subtitle: String
    var navigationTitle: String?
    var destination: T

    var body: some View {
        NavigationLink(destination: destination.navigationBarTitle(navigationTitle ?? label)) {
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
