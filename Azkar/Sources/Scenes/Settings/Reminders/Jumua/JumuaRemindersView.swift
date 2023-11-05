// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Combine

struct JumuaRemindersView: View {
    
    @StateObject var viewModel: JumuaRemindersViewModel
    @State private(set) var presentSoundPicker = false
    
    var body: some View {
        List {
            Group {
                Section {
                    Toggle(isOn: $viewModel.isNotificationsEnabled.animation(), label: {
                        Text(L10n.Settings.Reminders.Jumua.switchLabel)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 8)
                            .font(Font.system(.body, design: .rounded))
                    })
                }
                
                if viewModel.isNotificationsEnabled {
                    Section(
                        header:
                            Text(L10n.Settings.Reminders.header)
                    ) {
                        timePicker
                        
                        if viewModel.notificationsDisabledViewModel.isAccessGranted {
                            Button(
                                action: viewModel.presentSoundPicker,
                                label: {
                                    HStack {
                                        Text(L10n.Settings.Reminders.Sounds.sound)
                                            .foregroundColor(Color.text)
                                        
                                        Spacer()
                                        
                                        Text(viewModel.soundPickerViewModel.preferredSound.title)
                                            .foregroundColor(Color.secondary)
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color.secondary)
                                    }
                                    .font(Font.system(.body, design: .rounded))
                                }
                            )
                        } else {
                            notificationsDisabledView
                        }
                    }
                }
            }
            .listRowBackground(Color.contentBackground)
        }
        .sheet(isPresented: $presentSoundPicker) {
            NavigationView {
                ReminderSoundPickerView(viewModel: viewModel.soundPickerViewModel)
            }
        }
        .customScrollContentBackground()
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle(L10n.Settings.Reminders.Jumua.label)
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
