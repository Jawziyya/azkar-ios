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

    @State private var presentPicker = false

    var body: some View {
        Form {
            self.appearanceSection
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Настройки"), displayMode: .inline)
        .environment(\.horizontalSizeClass, .regular)
    }

    var appearanceSection: some View {
        Section {
            NavigationLink(destination: arabicFontPicker) {
                HStack(spacing: 8) {
                    Text("Шрифт арабского языка")
                    Spacer()
                    Text(viewModel.arabicFont.title)
                        .font(Font.caption)
                        .foregroundColor(Color.tertiaryText)
                }
                .padding(.vertical, 10)
            }
            .buttonStyle(PlainButtonStyle())

            NavigationLink(destination: themePicker) {
                HStack(spacing: 8) {
                    Text("Тема")
                    Spacer()
                    Text(viewModel.theme.title)
                        .font(Font.caption)
                        .foregroundColor(Color.tertiaryText)
                }
                .padding(.vertical, 10)
            }
            .buttonStyle(PlainButtonStyle())

            if viewModel.canChangeIcon {
                NavigationLink(destination: iconPicker) {
                    HStack(spacing: 8) {
                        Text("Значок приложения")
                        Spacer()
                        Text(viewModel.appIcon.title)
                            .font(Font.caption)
                            .foregroundColor(Color.tertiaryText)
                    }
                    .padding(.vertical, 10)
                }
                .buttonStyle(PlainButtonStyle())
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

}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel(preferences: Preferences()))
            .embedInNavigation()
    }
}
