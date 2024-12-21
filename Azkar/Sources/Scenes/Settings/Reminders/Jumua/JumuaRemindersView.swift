import SwiftUI
import Combine
import Library

struct JumuaRemindersView: View {
    
    @StateObject var viewModel: JumuaRemindersViewModel
    @State private(set) var presentSoundPicker = false
    
    var body: some View {
        ScrollView {
            VStack {
                Section {
                    Toggle(isOn: $viewModel.isNotificationsEnabled.animation(), label: {
                        Text(L10n.Settings.Reminders.Jumua.switchLabel)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 8)
                            .systemFont(.body)
                    })
                    
                    Divider()
                }
                
                if viewModel.isNotificationsEnabled {
                    timePicker
                    
                    Divider()
                    
                    if viewModel.notificationsDisabledViewModel.isAccessGranted {
                        NavigationButton(
                            title: L10n.Settings.Reminders.Sounds.sound,
                            label: viewModel.soundPickerViewModel.preferredSound.title,
                            action: viewModel.presentSoundPicker
                        )
                    } else {
                        notificationsDisabledView
                    }
                }
            }
            .applyContainerStyle()
        }
        .sheet(isPresented: $presentSoundPicker) {
            NavigationView {
                ReminderSoundPickerView(viewModel: viewModel.soundPickerViewModel)
            }
        }
        .customScrollContentBackground()
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle(L10n.Settings.Reminders.Jumua.label)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    @ViewBuilder
    var timePicker: some View {
        if UIDevice.current.isMac {
            Color.clear
        } else {
            iosTimePicker
        }
    }
    
    var iosTimePicker: some View {
        HStack {
            Text(L10n.Settings.Reminders.time)
                .fixedSize(horizontal: false, vertical: true)
                .systemFont(.body)
                .foregroundStyle(Color.text)
            
            Spacer()
            
            DatePicker(
                "Time",
                selection: $viewModel.preferences.jumuaReminderTime,
                in: viewModel.notificationDateRange,
                displayedComponents: [.hourAndMinute]
            )
            .labelsHidden()
        }
    }
    
    var notificationsDisabledView: some View {
        NotificationsDisabledView(viewModel: viewModel.notificationsDisabledViewModel)
    }
 
}

#Preview("JumuaRemindersView") {
    JumuaRemindersView(viewModel: JumuaRemindersViewModel(router: .empty))
}
