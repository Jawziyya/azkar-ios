import SwiftUI
import Library

struct RemindersScreen: View {
    
    @ObservedObject var viewModel: RemindersViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                content
            }
            .applyContainerStyle()
        }
        .foregroundStyle(Color.text)
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
                    .systemFont(.body)
                }
            
            if viewModel.preferences.enableNotifications && viewModel.notificationsDisabledViewModel.isAccessGranted {
                Divider()
                reminderTypes
            }
            
            if viewModel.preferences.enableNotifications && !viewModel.notificationsDisabledViewModel.isAccessGranted {
                Divider()
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
            NavigationButton(
                title: L10n.Settings.Reminders.MorningEvening.label,
                action: viewModel.navigateToAdhkarReminders
            )
            
            Divider()
            
            NavigationButton(
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
