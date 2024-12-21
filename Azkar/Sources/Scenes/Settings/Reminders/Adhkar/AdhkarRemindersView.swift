import SwiftUI
import Library

struct AdhkarRemindersView: View {
    
    @StateObject var viewModel: AdhkarRemindersViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                Section {
                    Toggle(isOn: $viewModel.isNotificationsEnabled.animation(), label: {
                        Text(L10n.Settings.Reminders.MorningEvening.switchLabel)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 8)
                            .systemFont(.body)
                            .foregroundStyle(Color.text)
                    })
                    Divider()
                }
                
                if viewModel.isNotificationsEnabled {
                    timePicker
                    
                    Divider()
                    
                    if viewModel.notificationsDisabledViewModel.isAccessGranted {
                        NavigationButton(
                            title: L10n.Settings.Reminders.Sounds.sound,
                            label: viewModel.preferences.adhkarReminderSound.title,
                            action: viewModel.presentSoundPicker
                        )
                    } else {
                        notificationsDisabledView
                    }
                }
            }
            .applyContainerStyle()
        }
        .customScrollContentBackground()
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle(L10n.Settings.Reminders.MorningEvening.label)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    @ViewBuilder
    var timePicker: some View {
        if UIDevice.current.isMac {
            macTimePicker
        } else {
            iosTimePicker
        }
    }
    
    var iosTimePicker: some View {
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
    
    var macTimePicker: some View {
        Group {
            PickerView(label: L10n.Settings.Reminders.MorningEvening.morningLabel, titleDisplayMode: .inline, subtitle: viewModel.morningTime, destination: macMorningTimePicker)
            
            PickerView(label: L10n.Settings.Reminders.MorningEvening.eveningLabel, titleDisplayMode: .inline, subtitle: viewModel.eveningTime, destination: macEveningTimePicker)
        }
    }
    
    var macMorningTimePicker: some View {
        ItemPickerView(
            selection: .init(get: {
                return viewModel.morningTime
            }, set: viewModel.setMorningTime),
            items: viewModel.morningDateItems,
            dismissOnSelect: true
        )
    }

    var macEveningTimePicker: some View {
        ItemPickerView(
            selection: .init(get: {
                return viewModel.eveningTime
            }, set: viewModel.setEveningTime),
            items: viewModel.eveningDateItems,
            dismissOnSelect: true
        )
    }
    
    var notificationsDisabledView: some View {
        NotificationsDisabledView(viewModel: viewModel.notificationsDisabledViewModel)
    }
    
}

struct MorningEveningRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdhkarRemindersView(
                viewModel: AdhkarRemindersViewModel(
                    router: .empty
                )
            )
        }
    }
}
