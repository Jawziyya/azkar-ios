import SwiftUI
import Library

struct RemindersScreen: View {
    
    @ObservedObject var viewModel: RemindersViewModel
    
    var showDebugNotifications = true
    
    var body: some View {
        ScrollView {
            VStack {
                content
            }
        }
        .foregroundStyle(.text)
        .applyThemedToggleStyle()
        .customScrollContentBackground()
        .background(.background, ignoreSafeArea: .all)
        .navigationTitle("settings.reminders.title")
        .modifier(
            ScheduledNotificationsToolbarModifier(
                isVisible: showDebugNotifications && UIApplication.shared.inDebugMode,
                action: viewModel.navigateToNotificationsList
            )
        )
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    var content: some View {
        Group {
            if viewModel.notificationsDisabledViewModel.isAccessGranted {
                morningReminderSection
                
                eveningReminderSection
                
                jumuaReminderSection
            } else {
                notificationsDisabledView
            }
        }
    }
    
    // MARK: - Morning Reminders Section
    
    var morningReminderSection: some View {
        VStack(spacing: 0) {
            HeaderView(text: "settings.reminders.morning-evening.morning-label")
            
            VStack {
                Toggle(
                    "settings.reminders.morning.switch-label",
                    isOn: $viewModel.preferences.enableMorningReminder
                )
                
                if viewModel.preferences.enableMorningReminder {
                    Divider()
                    
                    morningTimeRow
                    
                    Divider()
                    
                    NavigationButton(
                        title: "settings.reminders.title.section",
                        label: viewModel.morningTitleLabel(),
                        action: viewModel.presentMorningTitlePicker
                    )
                    
                    Divider()
                    
                    if viewModel.notificationsDisabledViewModel.isAccessGranted {
                        NavigationButton(
                            title: "settings.reminders.sounds.sound",
                            label: viewModel.preferences.morningReminderSound.title,
                            action: viewModel.presentMorningSoundPicker
                        )
                    }
                }
            }
            .applyContainerStyle()
        }
    }
    
    @ViewBuilder
    var morningTimeRow: some View {
        if UIDevice.current.isMac {
            PickerView(label: "settings.reminders.time", titleDisplayMode: .inline, subtitle: viewModel.morningTime, destination: adhkarMacMorningTimePicker)
        } else {
            HStack {
                Text("settings.reminders.time")
                    .fixedSize(horizontal: false, vertical: true)
                    .systemFont(.body)
                    .foregroundStyle(.text)
                
                Spacer()
                
                DatePicker(
                    "settings.reminders.time",
                    selection: viewModel.morningTimeSelection,
                    in: viewModel.morningNotificationDateRange,
                    displayedComponents: [.hourAndMinute]
                )
                .labelsHidden()
            }
        }
    }
    
    // MARK: - Evening Reminders Section
    
    var eveningReminderSection: some View {
        VStack(spacing: 0) {
            HeaderView(text: "settings.reminders.morning-evening.evening-label")
            
            VStack {
                Toggle(
                    "settings.reminders.evening.switch-label",
                    isOn: $viewModel.preferences.enableEveningReminder
                )
                
                if viewModel.preferences.enableEveningReminder {
                    Divider()
                    
                    eveningTimeRow
                    
                    Divider()
                    
                    NavigationButton(
                        title: "settings.reminders.title.section",
                        label: viewModel.eveningTitleLabel(),
                        action: viewModel.presentEveningTitlePicker
                    )
                    
                    Divider()
                    
                    if viewModel.notificationsDisabledViewModel.isAccessGranted {
                        NavigationButton(
                            title: "settings.reminders.sounds.sound",
                            label: viewModel.preferences.eveningReminderSound.title,
                            action: viewModel.presentEveningSoundPicker
                        )
                    }
                }
            }
            .applyContainerStyle()
        }
    }
    
    @ViewBuilder
    var eveningTimeRow: some View {
        if UIDevice.current.isMac {
            PickerView(label: "settings.reminders.time", titleDisplayMode: .inline, subtitle: viewModel.eveningTime, destination: adhkarMacEveningTimePicker)
        } else {
            HStack {
                Text("settings.reminders.time")
                    .fixedSize(horizontal: false, vertical: true)
                    .systemFont(.body)
                    .foregroundStyle(.text)
                
                Spacer()
                
                DatePicker(
                    "settings.reminders.time",
                    selection: viewModel.eveningTimeSelection,
                    in: viewModel.eveningNotificationDateRange,
                    displayedComponents: [.hourAndMinute]
                )
                .labelsHidden()
            }
        }
    }
        
    var adhkarMacMorningTimePicker: some View {
        ItemPickerView(
            selection: .init(get: {
                return viewModel.morningTime
            }, set: viewModel.setMorningTime),
            items: viewModel.morningDateItems,
            dismissOnSelect: true
        )
    }

    var adhkarMacEveningTimePicker: some View {
        ItemPickerView(
            selection: .init(get: {
                return viewModel.eveningTime
            }, set: viewModel.setEveningTime),
            items: viewModel.eveningDateItems,
            dismissOnSelect: true
        )
    }
    
    // MARK: - Jumua Reminders Section
    var jumuaReminderSection: some View {
        VStack(spacing: 0) {
            HeaderView(text: "settings.reminders.jumua.label")
            
            VStack {
                Toggle(
                    "settings.reminders.jumua.switch-label",
                    isOn: $viewModel.preferences.enableJumuaReminder
                )
                
                if viewModel.preferences.enableJumuaReminder {
                    Divider()
                    
                    jumuaTimePicker
                    
                    Divider()

                    NavigationButton(
                        title: "settings.reminders.title.section",
                        label: viewModel.jumuaTitleLabel(),
                        action: viewModel.presentJumuaTitlePicker
                    )

                    Divider()
                    
                    if viewModel.notificationsDisabledViewModel.isAccessGranted {
                        NavigationButton(
                            title: "settings.reminders.sounds.sound",
                            label: viewModel.preferences.jumuahDuaReminderSound.title,
                            action: viewModel.presentJumuaSoundPicker
                        )
                    }
                }
            }
            .applyContainerStyle()
        }
    }
    
    @ViewBuilder
    var jumuaTimePicker: some View {
        if UIDevice.current.isMac {
            jumuaMacTimePicker
        } else {
            jumuaIosTimePicker
        }
    }
    
    var jumuaMacTimePicker: some View {
        PickerView(
            label: "settings.reminders.jumua.label",
            titleDisplayMode: .inline,
            subtitle: viewModel.jumuaReminderTime,
            destination: jumuaMacEveningTimePicker
        )
    }
    
    var jumuaMacEveningTimePicker: some View {
        ItemPickerView(
            selection: .init(get: {
                return viewModel.jumuaReminderTime
            }, set: viewModel.setJumuaReminderTime(_:)),
            items: viewModel.jumuaDateItems,
            dismissOnSelect: true
        )
    }
    
    var jumuaIosTimePicker: some View {
        HStack {
            Text("settings.reminders.time")
                .fixedSize(horizontal: false, vertical: true)
                .systemFont(.body)
                .foregroundStyle(.text)
            
            Spacer()
            
            DatePicker(
                "Time",
                selection: viewModel.jumuaTimeSelection,
                in: viewModel.jumuaNotificationDateRange,
                displayedComponents: [.hourAndMinute]
            )
            .labelsHidden()
        }
    }
    
    var notificationsDisabledView: some View {
        NotificationsDisabledView(viewModel: viewModel.notificationsDisabledViewModel)
    }
}

/// Adds the debug "scheduled notifications" toolbar button only when visible, so
/// no empty toolbar item (or empty Liquid Glass pill) is rendered otherwise.
private struct ScheduledNotificationsToolbarModifier: ViewModifier {
    let isVisible: Bool
    let action: () -> Void

    func body(content: Content) -> some View {
        if isVisible {
            content.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: action) {
                        Image(systemName: "bell.badge")
                    }
                    .accessibilityLabel(Text(verbatim: "Scheduled notifications"))
                }
            }
        } else {
            content
        }
    }
}

#Preview("RemindersScreen") {
    RemindersScreen(
        viewModel: RemindersViewModel(
            navigator: EmptySettingsNavigator()
        )
    )
}
