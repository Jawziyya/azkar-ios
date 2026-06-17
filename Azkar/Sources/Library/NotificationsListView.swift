import SwiftUI

protocol UserNotification {
    var title: String { get }
    var subtitle: String? { get }
    var body: String? { get }
    var date: Date { get }
    var details: String { get }
    var category: String? { get }
    var identifier: String { get }
}

extension UNNotificationRequest: UserNotification {

    var title: String {
        return content.title
    }

    var subtitle: String? {
        return content.subtitle.isEmpty ? nil : content.subtitle
    }

    var body: String? {
        return content.body.isEmpty ? nil : content.body
    }

    var date: Date {
        return (trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate()
            ?? Date()
    }

    var soundInfo: String? {
        if let raw = content.userInfo[NotificationUserInfoKey.sound] as? String {
            return ReminderSound(rawValue: raw)?.title ?? raw
        }
        return content.sound == nil ? nil : "Default"
    }

    var category: String? {
        content.categoryIdentifier.isEmpty ? nil : content.categoryIdentifier
    }

    var details: String {
        var lines = ["ID: \(identifier)", "Sound: \(soundInfo ?? "n/a")"]
        if let body {
            lines.insert("Body: \(body)", at: 1)
        }
        return lines.joined(separator: "\n")
    }

}

struct DummyUserNotification: UserNotification {
    var title: String
    var subtitle: String? = "Quran 13:28"
    var body: String?
    var date: Date
    var details: String = UUID().uuidString
    var category: String? = ["morning", "evening", "jumua"].randomElement()
    var identifier: String = UUID().uuidString
}

struct NotificationDaySection: Identifiable {
    let id: String
    let title: String
    let rows: [NotificationsRowViewModel]
}

final class NotificationsListViewModel: ObservableObject {
    @Published var sections: [NotificationDaySection] = []

    var totalCount: Int {
        sections.reduce(0) { $0 + $1.rows.count }
    }

    var isEmpty: Bool {
        sections.isEmpty
    }

    var numberOfNotifications: String {
        "Total scheduled notifications: \(totalCount)"
    }

    init(notifications: @escaping (() async -> [UserNotification])) {
        Task(priority: .userInitiated) {
            let notifications = await notifications()
            let calendar = Calendar.current

            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE, d MMMM yyyy"

            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .short

            let sorted = notifications.sorted { $0.date < $1.date }
            let grouped = Dictionary(grouping: sorted) { calendar.startOfDay(for: $0.date) }

            var globalIndex = 0
            let sections = grouped.keys.sorted().map { day -> NotificationDaySection in
                let rows = (grouped[day] ?? []).map { notification -> NotificationsRowViewModel in
                    let row = NotificationsRowViewModel(
                        row: globalIndex,
                        title: notification.title,
                        subtitle: notification.subtitle,
                        body: notification.body,
                        date: timeFormatter.string(from: notification.date),
                        category: notification.category,
                        details: notification.details
                    )
                    globalIndex += 1
                    return row
                }
                return NotificationDaySection(
                    id: dayFormatter.string(from: day),
                    title: dayFormatter.string(from: day),
                    rows: rows
                )
            }

            await MainActor.run {
                self.sections = sections
            }
        }
    }

    func removeScheduledNotifications() {
        sections = []
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

}

struct NotificationsRowViewModel {
    let row: Int
    let title: String
    let subtitle: String?
    let body: String?
    let date: String
    let category: String?
    let details: String

    var categoryLabel: String? {
        category?.capitalized
    }

    var categoryColor: Color {
        switch category {
        case "morning": return .orange
        case "evening": return .indigo
        case "jumua": return .green
        default: return .gray
        }
    }

    var accessibilitySummary: String {
        [
            String(
                format: String(localized: "accessibility.notifications.item-number"),
                locale: Locale.current,
                row + 1
            ),
            categoryLabel,
            title,
            subtitle,
            body,
            date,
            details
        ]
        .compactMap { $0 }
        .joined(separator: ", ")
    }
}

private struct NotificationsRowView: View {
    let vm: NotificationsRowViewModel
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text("Notification #\(vm.row + 1)")
                    .foregroundStyle(.secondary)
                    .font(.callout.smallCaps())

                if let categoryLabel = vm.categoryLabel {
                    Text(categoryLabel)
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(vm.categoryColor, in: Capsule())
                }

                Spacer()

                Text(vm.date)
                    .foregroundStyle(Color.primary)
                    .font(.footnote)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(vm.title)
                            .foregroundStyle(.primary)
                            .font(.callout)
                            .multilineTextAlignment(.leading)

                        if let subtitle = vm.subtitle {
                            Text(subtitle)
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    Spacer()
                }

                Text(vm.details)
                    .foregroundStyle(.secondary)
                    .font(.caption2)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(16)
        .cornerRadius(15)
        .padding(.horizontal, 16)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(vm.accessibilitySummary)
    }
}

struct NotificationsListView: View {
    
    @ObservedObject var viewModel: NotificationsListViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [.init(.flexible(minimum: 100))],
                alignment: .center,
                spacing: 0,
                pinnedViews: [],
                content: {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Notifications")
                                    .font(.largeTitle.bold())
                                Text(viewModel.numberOfNotifications)
                                    .foregroundStyle(.secondary)
                                    .font(.callout)
                            }
                            .multilineTextAlignment(.leading)
                            Spacer()
                            Button(action: viewModel.removeScheduledNotifications, label: {
                                Image(systemName: "trash")
                            })
                            .accessibilityLabel(Text("accessibility.notifications.remove-scheduled"))
                            .disabled(viewModel.isEmpty)
                        }
                        .padding()

                        if viewModel.isEmpty {
                            Text("No scheduled notifications")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(viewModel.sections) { section in
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack {
                                        Text(section.title)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                        Spacer()
                                        Text("\(section.rows.count)")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.top, 12)
                                    .padding(.bottom, 4)

                                    ForEach(section.rows, id: \.row) { vm in
                                        NotificationsRowView(vm: vm)
                                            .background(.contentBackground)
                                    }
                                }
                            }
                        }
                    }
                }
            )
        }
        .background(.background, ignoreSafeArea: .all)
        .background(
            Text("This view is only visible in test builds")
                .ignoresSafeArea(edges: .bottom)
                .foregroundStyle(.secondary)
            ,
            alignment: .bottom
        )
    }
    
}

struct NotificationsListView_Previews: PreviewProvider {

    static var previews: some View {
        let notifications: [DummyUserNotification] = (1...10).map { _ in
            DummyUserNotification(title: UUID().uuidString, body: nil, date: Date())
        }
        let viewModel = NotificationsListViewModel(
            notifications: { notifications }
        )
        return NotificationsListView(viewModel: viewModel)
    }

}
