import SwiftUI
import Library

struct RemindersScreen: View {
    
    @ObservedObject var viewModel: RemindersViewModel
    
    var showDebugNotificataions = false
    
    var body: some View {
        ScrollView {
            VStack {
                content
            }
        }
        .foregroundStyle(Color.text)
        .applyThemedToggleStyle()
        .customScrollContentBackground()
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .navigationTitle(L10n.Settings.Reminders.title)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    var content: some View {
        Group {
            if viewModel.notificationsDisabledViewModel.isAccessGranted {
                adhkarReminderSection
                
                jumuaReminderSection
            } else {
                notificationsDisabledView
            }
            
            if showDebugNotificataions && UIApplication.shared.inDebugMode {
                Divider()
                Button(action: viewModel.navigateToNotificationsList) {
                    Text("[DEBUG] Scheduled notifications")
                        .padding(.vertical, 8)
                }
            }
        }
    }
    
    // MARK: - Adhkar Reminders Section
    
    var adhkarReminderSection: some View {
        VStack(spacing: 0) {
            HeaderView(title: L10n.Settings.Reminders.MorningEvening.label)
            
            VStack {
                Toggle(
                    L10n.Settings.Reminders.MorningEvening.switchLabel,
                    isOn: $viewModel.preferences.enableAdhkarReminder
                )
                
                if viewModel.preferences.enableAdhkarReminder {
                    Divider()
                    
                    adhkarTimePicker
                    
                    Divider()
                    
                    if viewModel.notificationsDisabledViewModel.isAccessGranted {
                        NavigationButton(
                            title: L10n.Settings.Reminders.Sounds.sound,
                            label: viewModel.preferences.adhkarReminderSound.title,
                            action: viewModel.presentAdhkarSoundPicker
                        )
                    }
                }
            }
            .applyContainerStyle()
        }
    }
    
    @ViewBuilder
    var adhkarTimePicker: some View {
        if UIDevice.current.isMac {
            adhkarMacTimePicker
        } else {
            adhkarIosTimePicker
        }
    }
    
    var adhkarIosTimePicker: some View {
        Group {
            HStack {
                Text(L10n.Settings.Reminders.MorningEvening.morningLabel)
                    .fixedSize(horizontal: false, vertical: true)
                    .systemFont(.body)
                    .foregroundStyle(Color.text)
                
                Spacer()
                
                DatePicker(
                    L10n.Settings.Reminders.MorningEvening.morningLabel,
                    selection: $viewModel.preferences.morningNotificationTime,
                    in: viewModel.morningNotificationDateRange,
                    displayedComponents: [.hourAndMinute]
                )
                .labelsHidden()
            }
            
            Divider()
            
            HStack {
                Text(L10n.Settings.Reminders.MorningEvening.eveningLabel)
                    .fixedSize(horizontal: false, vertical: true)
                    .systemFont(.body)
                    .foregroundStyle(Color.text)
                
                Spacer()
                
                DatePicker(
                    L10n.Settings.Reminders.MorningEvening.eveningLabel,
                    selection: $viewModel.preferences.eveningNotificationTime,
                    in: viewModel.eveningNotificationDateRange,
                    displayedComponents: [.hourAndMinute]
                )
                .labelsHidden()
            }
        }
    }
    
    var adhkarMacTimePicker: some View {
        Group {
            PickerView(label: L10n.Settings.Reminders.MorningEvening.morningLabel, titleDisplayMode: .inline, subtitle: viewModel.morningTime, destination: adhkarMacMorningTimePicker)
            
            PickerView(label: L10n.Settings.Reminders.MorningEvening.eveningLabel, titleDisplayMode: .inline, subtitle: viewModel.eveningTime, destination: adhkarMacEveningTimePicker)
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
            HeaderView(title: L10n.Settings.Reminders.Jumua.label)
            
            VStack {
                Toggle(
                    L10n.Settings.Reminders.Jumua.switchLabel,
                    isOn: $viewModel.preferences.enableJumuaReminder
                )
                
                if viewModel.preferences.enableJumuaReminder {
                    Divider()
                    
                    jumuaTimePicker
                    
                    Divider()
                    
                    if viewModel.notificationsDisabledViewModel.isAccessGranted {
                        NavigationButton(
                            title: L10n.Settings.Reminders.Sounds.sound,
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
            label: L10n.Settings.Reminders.Jumua.label,
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
            Text(L10n.Settings.Reminders.time)
                .fixedSize(horizontal: false, vertical: true)
                .systemFont(.body)
                .foregroundStyle(Color.text)
            
            Spacer()
            
            DatePicker(
                "Time",
                selection: $viewModel.preferences.jumuaReminderTime,
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

#Preview("RemindersScreen") {
    RemindersScreen(
        viewModel: RemindersViewModel(
            router: .empty
        )
    )
}
