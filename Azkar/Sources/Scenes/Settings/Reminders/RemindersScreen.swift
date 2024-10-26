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
        .navigationTitle(L10n.Settings.Reminders.title)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
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
            ChevronButton(
                title: L10n.Settings.Reminders.MorningEvening.label,
                action: viewModel.navigateToAdhkarReminders
            )
            
            ChevronButton(
                title: L10n.Settings.Reminders.Jumua.label,
                action: viewModel.navigateToJumuaReminders
            )
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
