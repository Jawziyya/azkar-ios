// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI

struct AdhkarRemindersView: View {
    
    @StateObject var viewModel: AdhkarRemindersViewModel
    @State private(set) var presentSoundPicker = false
    
    var body: some View {
        Form {
            Group {
                Section {
                    Toggle(isOn: $viewModel.isNotificationsEnabled.animation(), label: {
                        Text(L10n.Settings.Reminders.MorningEvening.switchLabel)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 8)
                            .font(Font.system(.body, design: .rounded))
                    })
                }
                
                if viewModel.isNotificationsEnabled {
                    Section(
                        header:
                            Text("Настройки уведомлений")
                    ) {
                        timePicker
                        
                        if viewModel.notificationsDisabledViewModel.isAccessGranted {
                            Button(action: {
                                presentSoundPicker.toggle()
                            }) {
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
        .accentColor(Color.accent)
        .toggleStyle(SwitchToggleStyle(tint: Color.accent))
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle(L10n.Settings.Reminders.MorningEvening.label)
        .navigationBarTitleDisplayMode(.inline)
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
                
                Spacer()
                
                DatePicker(
                    L10n.Settings.Reminders.MorningEvening.morningLabel,
                    selection: $viewModel.morningDate,
                    in: viewModel.morningNotificationDateRange,
                    displayedComponents: [.hourAndMinute]
                )
                .labelsHidden()
            }
            
            HStack {
                Text(L10n.Settings.Reminders.MorningEvening.eveningLabel)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                DatePicker(
                    L10n.Settings.Reminders.MorningEvening.eveningLabel,
                    selection: $viewModel.eveningDate,
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
            AdhkarRemindersView(viewModel: AdhkarRemindersViewModel(subscribeScreenTrigger: {}))
        }
    }
}
