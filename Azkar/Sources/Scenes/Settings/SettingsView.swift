//  Copyright © 2020 Al Jawziyya. All rights reserved.

import SwiftUI
import Popovers
import Entities

enum SettingsSection: Equatable {
    case root, themes, arabicFonts, fonts, icons
}

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}

extension Language: PickableItem {}

struct SettingsView: View {

    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        List {
            Group {
                switch viewModel.mode {
                case .standart:
                    appearanceSection
                    counterSection
                    textSettingsSection
                    remindersSection
                case .text:
                    textSettingsSection
                }
            }
        }
        .listStyle(.insetGrouped)
        .accentColor(Color.accent)
        .toggleStyle(SwitchToggleStyle(tint: Color.accent))
        .horizontalPaddingForLargeScreen()
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Appearance
    var appearanceSection: some View {
        Section(
            header: getHeader(symbolName: "paintbrush", title: L10n.Settings.Theme.title)
                .accentColor(Color.accent)
                .foregroundColor(Color.white)
        ) {
            PickerView(
                label: L10n.Settings.Theme.title,
                titleDisplayMode: .inline,
                subtitle: viewModel.themeTitle,
                destination: themePicker
            )

            if viewModel.canChangeIcon {
                PickerView(
                    label: L10n.Settings.Icon.title,
                    titleDisplayMode: .inline,
                    subtitle: viewModel.preferences.appIcon.title,
                    destination: iconPicker
                )
            }

            Toggle(isOn: $viewModel.preferences.enableFunFeatures) {
                HStack {
                    Text(L10n.Settings.useFunFeatures)
                        .font(Font.system(.body, design: .rounded))
                    Spacer()

                    Templates.Menu {
                        Text(L10n.Settings.useFunFeaturesTip)
                            .padding()
                    } label: { _ in
                        Image(systemName: "info.circle")
                            .foregroundColor(Color.accent.opacity(0.75))
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
                    HStack {
                        Text(L10n.Settings.Counter.counterType)
                        Spacer()

                        Templates.Menu {
                            Text(L10n.Settings.Counter.counterTypeInfo)
                                .padding()
                        } label: { _ in
                            Image(systemName: "info.circle")
                                .foregroundColor(Color.accent.opacity(0.75))
                        }

                        Picker(
                            CounterType.allCases,
                            id: \.self,
                            selection: $viewModel.preferences.counterType,
                            content: { type in
                                Text(type.title)
                            }
                        )
                        .pickerStyle(.segmented)
                    }
                    .padding(.vertical, 3)

                    Toggle(L10n.Settings.Counter.counterTicker, isOn: $viewModel.preferences.enableCounterTicker)
                        .padding(.vertical, 3)

                    Toggle(L10n.Settings.Counter.counterHaptics, isOn: $viewModel.preferences.enableCounterHapticFeedback)
                        .padding(.vertical, 3)

                    Toggle(isOn: $viewModel.preferences.enableGoToNextZikrOnCounterFinished) {
                        HStack {
                            Text(L10n.Settings.Counter.goToNextDhikr)
                                .font(Font.system(.body, design: .rounded))

                            Spacer()

                            Templates.Menu {
                                Text(L10n.Settings.Counter.goToNextDhikrTip)
                            } label: { _ in
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color.accent.opacity(0.75))
                            }
                        }
                        .padding(.vertical, 3)
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
    
    var contentLanguagePicker: some View {
        ItemPickerView(
            selection: $viewModel.preferences.contentLanguage,
            items: viewModel.getAvailableLanguages(),
            dismissOnSelect: true
        )
    }
    
    // MARK: - Content Size
    var textSettingsSection: some View {
        Section(
            header: getHeader(symbolName: "bold.italic.underline", title: L10n.Settings.Text.title)
                .accentColor(Color.blue.opacity(0.25))
                .foregroundColor(Color.background)
                .symbolRenderingMode(.multicolor)
        ) {
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
                        titleDisplayMode: .inline,
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
            
            NavigationLink {
                Form {
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
                .navigationBarTitle(L10n.Settings.Text.lineSpacing)
                .accentColor(Color.accent)
                .horizontalPaddingForLargeScreen()
                .background(Color.background.edgesIgnoringSafeArea(.all))
            } label: {
                createNavigationPickerLabel(
                    label: L10n.Settings.Text.lineSpacing,
                    value: ""
                )
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
        .padding(.vertical, 8)
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
                        .padding(.vertical, 8)
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(
                viewModel: SettingsViewModel(
                    databaseService: DatabaseService(language: .english),
                    preferences: Preferences.shared,
                    router: RootCoordinator(
                        preferences: Preferences.shared,
                        deeplinker: Deeplinker(),
                        player: Player.test
                    )
                )
            )
        }
    }
    
}
