// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Combine

final class JumuaRemindersViewModel: ObservableObject {
    
    @Published var isNotificationsEnabled = true
    @Published var formattedTime = ""
    @Published var time = Date()
    
    let soundPickerViewModel: ReminderSoundPickerViewModel
    private let preferences: Preferences
    private var cancellables = Set<AnyCancellable>()
    
    init(
        preferences: Preferences = Preferences.shared,
        subscriptionManager: SubscriptionManagerType = SubscriptionManagerFactory.create(),
        subscribeScreenTrigger: @escaping Action
    ) {
        self.preferences = preferences
        isNotificationsEnabled = preferences.enableJumuaReminder
        soundPickerViewModel = ReminderSoundPickerViewModel(
            preferredSound: preferences.jumuahDuaReminderSound,
            subscriptionManager: subscriptionManager,
            subscribeScreenTrigger: subscribeScreenTrigger
        )
        
        $isNotificationsEnabled
            .assign(to: \.enableJumuaReminder, on: preferences)
            .store(in: &cancellables)
        
        soundPickerViewModel.$preferredSound
            .assign(to: \.jumuahDuaReminderSound, on: preferences)
            .store(in: &cancellables)
        
        soundPickerViewModel.$preferredSound.eraseToAnyPublisher().toVoid()
            .sink(receiveValue: { [weak self] in
                self?.objectWillChange.send()
            })
            .store(in: &cancellables)
    }
    
    var notificationDateRange: ClosedRange<Date> {
        let minDate = DateComponents(calendar: Calendar.current, hour: 10, minute: 0).date ?? Date()
        let maxDate = DateComponents(calendar: Calendar.current, hour: 18, minute: 0).date ?? Date()
        return minDate ... maxDate
    }

    func getDatesRange(fromHour hour: Int, hours: Int) -> [Date] {
        let now = DateComponents(calendar: Calendar.current, hour: hour, minute: 0).date ?? Date()
        return (1...(hours * 2)).reduce(into: [now]) { (dates, multiplier) in
            let duration = DateComponents(calendar: Calendar.current, minute: multiplier * 30)
            let newDate = Calendar.current.date(byAdding: duration, to: now) ?? now
            dates.append(newDate)
        }
    }
    
}

struct JumuaRemindersView: View {
    
    @StateObject var viewModel: JumuaRemindersViewModel
    @State private(set) var presentSoundPicker = false
    
    var body: some View {
        Form {
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
                            Text("Настройки уведомлений")
                    ) {
                        timePicker
                        
                        Button(action: {
                            presentSoundPicker.toggle()
                        }) {
                            HStack {
                                Text(L10n.Settings.Reminders.Sounds.sound)
                                    .foregroundColor(Color.text)
                                
                                Spacer()
                                
                                Text(viewModel.soundPickerViewModel.preferredSound.title)
                                    .foregroundColor(Color.secondaryText)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.secondary)
                            }
                            .font(Font.system(.body, design: .rounded))
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
        .navigationTitle(L10n.Settings.Reminders.Jumua.label)
        .navigationBarTitleDisplayMode(.inline)
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
                selection: $viewModel.time,
                in: viewModel.notificationDateRange,
                displayedComponents: [.hourAndMinute]
            )
            .labelsHidden()
        }
    }
 
}

struct JumuaRemindersView_Previews: PreviewProvider {
    static var previews: some View {
        JumuaRemindersView(viewModel: JumuaRemindersViewModel())
    }
}
