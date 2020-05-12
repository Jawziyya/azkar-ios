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
            self.notificationsSection
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(Text("Настройки"), displayMode: .inline)
    }

    // MARK: - Appearance
    var appearanceSection: some View {
        Section(header: Text("Настройки отображения")) {
            picker(with: "Шрифт арабского языка", subtitle: viewModel.arabicFont.title, destination: arabicFontPicker)

            picker(with: "Тема", subtitle: viewModel.theme.title, destination: themePicker)

            if viewModel.canChangeIcon {
                picker(with: "Значок приложения", subtitle: viewModel.appIcon.title, destination: iconPicker)
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
            selection: $viewModel.appIcon,
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
                picker(with: "Напоминание об утренних азкарах", subtitle: viewModel.morningTime, destination: morningTimePicker)

                picker(with: "Напоминание о вечерних азкарах", subtitle: viewModel.eveningTime, destination: eveningTimePicker)
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

    // MARK: - Common
    func picker<T: View>(with label: String, subtitle: String, navigationTitle: String? = nil, destination: T) -> some View {
        NavigationLink(destination: destination.navigationBarTitle(navigationTitle ?? label)) {
            HStack(spacing: 8) {
                Text(label)
                Spacer()
                Text(subtitle)
                    .font(Font.caption)
                    .foregroundColor(Color.secondary)
            }
            .padding(.vertical, 10)
            .buttonStyle(PlainButtonStyle())
        }
    }

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(preferences: Preferences()))
            .embedInNavigation()
    }
}
