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
            if viewModel.notificationsDisabledViewModel.isAccessGranted {
                reminderTypes
            } else {
                notificationsDisabledView
            }
            
            Divider()
            
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
