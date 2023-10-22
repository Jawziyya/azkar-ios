// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI

struct RemindersScreen: View {
    
    @ObservedObject var viewModel: RemindersViewModel
    
    var body: some View {
        List {
            content
                .listRowBackground(Color.contentBackground)
        }
        .customScrollContentBackground()
        .background(Color.background, ignoresSafeAreaEdges: .all)
    }
    
    var content: some View {
        Group {
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

#Preview {
    RemindersScreen(
        viewModel: RemindersViewModel(
            router: .empty
        )
    )
}
