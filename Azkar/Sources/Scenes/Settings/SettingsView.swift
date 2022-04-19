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
    @State private var showGoToNextZikrTip = false

    var body: some View {
        Form {
            Group {
                appearanceSection
                counterSection
                textSettingsSection
                
                if viewModel.mode != .textAndAppearance {
                    remindersSection
                }
            }
            .listRowBackground(Color.contentBackground)
        }
        .accentColor(Color.accent)
        .toggleStyle(SwitchToggleStyle(tint: Color.accent))
        .horizontalPaddingForLargeScreen()
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }
    
    func getHeader(symbolName: String, title: String) -> some View {
        HStack {
            Image(systemName: symbolName)
                .font(.caption.bold())
                .aspectRatio(contentMode: .fit)
                .padding(3)
                .background(Color.accentColor.cornerRadius(4))
            Text(title)
                .font(Font.system(.caption, design: .rounded))
                .foregroundColor(Color.secondaryText)
        }
    }

    // MARK: - Appearance
    var appearanceSection: some View {
        Section(
            header: getHeader(symbolName: "paintbrush", title: L10n.Settings.Theme.title)
                .accentColor(Color.accent)
                .foregroundColor(Color.white)
        ) {
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

    var counterSection: some View {
        Section(
            header: getHeader(symbolName: "arrow.counterclockwise", title: L10n.Settings.Counter.sectionTitle)
                .accentColor(Color(.systemCyan))
                .foregroundColor(Color.white)
            ,
            content: {
                if viewModel.preferences.enableCounter {
                    Toggle(L10n.Settings.Counter.counterTicker, isOn: $viewModel.preferences.enableCounterTicker)

                    Toggle(L10n.Settings.Counter.counterHaptics, isOn: $viewModel.preferences.enableCounterHapticFeedback)

                    Toggle(isOn: $viewModel.preferences.enableGoToNextZikrOnCounterFinished) {
                        HStack {
                            Text(L10n.Settings.Counter.goToNextDhikr)
                                .font(Font.system(.body, design: .rounded))
                            Spacer()
                            Button { } label: {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color.accent.opacity(0.75))
                            }
                            .onTapGesture {
                                self.showGoToNextZikrTip = true
                            }
                            .alert(isPresented: $showGoToNextZikrTip) {
                                Alert(
                                    title: Text(L10n.Settings.Counter.goToNextDhikrTip),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        )
    }
    
    var arabicFontsPicker: some View {
        FontsView(viewModel: viewModel.getFontsViewModel(fontsType: .arabic))
    }
    
    var translationFontsPicker: some View {
        FontsView(viewModel: viewModel.getFontsViewModel(fontsType: .translation))
    }

    var themePicker: some View {
        ColorSchemesView(viewModel: viewModel.colorSchemeViewModel)
    }

    var iconPicker: some View {
        AppIconPackListView(viewModel: viewModel.appIconPackListViewModel)
    }
    
    // MARK: - Content Size
    var textSettingsSection: some View {
        Section(
            header: getHeader(symbolName: "bold.italic.underline", title: L10n.Settings.Text.title)
                .accentColor(Color.blue.opacity(0.25))
                .foregroundColor(Color.background)
                .symbolRenderingMode(.multicolor)
        ) {
            NavigationLink {
                arabicFontsPicker
            } label: {
                HStack {
                    Text(L10n.Settings.Text.arabicTextFont)
                        .font(Font.system(.body, design: .rounded))
                        .foregroundColor(Color.text)
                    Spacer()
                    Text(viewModel.preferences.preferredArabicFont.name)
                        .multilineTextAlignment(.trailing)
                        .font(Font.system(.body, design: .rounded))
                        .foregroundColor(Color.secondary)
                }
            }
            
            NavigationLink {
                translationFontsPicker
            } label: {
                HStack {
                    Text(L10n.Settings.Text.translationTextFont)
                        .font(Font.system(.body, design: .rounded))
                        .foregroundColor(Color.text)
                    Spacer()
                    Text(viewModel.preferences.preferredTranslationFont.name)
                        .multilineTextAlignment(.trailing)
                        .font(Font.system(.body, design: .rounded))
                        .foregroundColor(Color.secondary)
                }
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


            VStack(alignment: .leading, spacing: 16) {
                Divider()
                    .padding(.horizontal, -20)
                Text(L10n.Settings.Text.lineHeight)
                lineHeightPicker
            }
            .padding(.vertical, 8)
        }
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
        .pickerStyle(SegmentedPickerStyle())
    }

    var lineHeightPicker: some View {
        Picker(
            selection: $viewModel.preferences.lineHeight,
            label: Text(L10n.Settings.Text.fontSize)
                .font(Font.system(.body, design: .rounded))
                .padding(.vertical, 8)
        ) {
            ForEach(LineHeight.allCases) { height in
                Text(height.title)
                    .font(Font.system(.body, design: .rounded))
                    .tag(height)
            }
        }
        .pickerStyle(.segmented)
    }
    
    var remindersSection: some View {
        Section(
            header: getHeader(symbolName: "bell.fill", title: L10n.Settings.Reminders.title)
                .foregroundColor(Color.white)
                .accentColor(Color.orange)
        ) {
            Toggle(
                isOn: Binding(get: {
                    viewModel.preferences.enableNotifications
                }, set: { newValue in
                    viewModel.enableReminders(newValue)
                }).animation()) {
                    Text(L10n.Settings.Reminders.enable)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 8)
                    .font(Font.system(.body, design: .rounded))
                }
            
            if viewModel.preferences.enableNotifications && viewModel.notificationsDisabledViewModel.isAccessGranted {
                reminderTypes
            }
            
            if viewModel.preferences.enableNotifications && !viewModel.notificationsDisabledViewModel.isAccessGranted {
                notificationsDisabledView
            }
            
            if UIApplication.shared.inDebugMode {
                Button(action: viewModel.navigateToNotificationsList) {
                    Text("[DEBUG] Scheduled notifications")
                        .padding()
                }
            }
        }
    }
    
    var reminderTypes: some View {
        Group {
            NavigationLink {
                AdhkarRemindersView(viewModel: viewModel.adhkarRemindersViewModel)
            } label: {
                Text(L10n.Settings.Reminders.MorningEvening.label)
            }

            NavigationLink {
                JumuaRemindersView(viewModel: viewModel.jumuaRemindersViewModel)
            } label: {
                Text(L10n.Settings.Reminders.Jumua.label)
            }
        }
    }
    
    var notificationsDisabledView: some View {
        NotificationsDisabledView(viewModel: viewModel.notificationsDisabledViewModel)
    }

}

struct PickerView<T: View>: View {

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
            viewModel: SettingsViewModel(
                preferences: Preferences.shared,
                router: RootCoordinator(
                    preferences: Preferences.shared,
                    deeplinker: Deeplinker(),
                    player: Player.test
                )
            )
        )
        .environment(\.colorScheme, .dark)
    }
}
