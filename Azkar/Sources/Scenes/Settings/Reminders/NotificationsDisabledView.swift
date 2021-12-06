// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Combine

final class NotificationsDisabledViewModel: ObservableObject {
    
    private(set) var notificationAccessTitle = ""
    private(set) var notificationAccessMessage = ""
    private(set) var symbolName = ""
    @Published var isAccessGranted = true
    
    private var cancellables = Set<AnyCancellable>()
    private let observationType: ObservationType
    
    enum ObservationType {
        case generalAccess, soundAccess
        
        var title: String {
            switch self {
            case .generalAccess:
                return L10n.Settings.Reminders.NoAccess.titleGeneral
            case .soundAccess:
                return L10n.Settings.Reminders.NoAccess.titleSound
            }
        }
        
        var symbolName: String {
            switch self {
            case .generalAccess:
                return "exclamationmark.circle.fill"
            case .soundAccess:
                return "speaker.slash.circle.fill"
            }
        }
    }
    
    init(observationType: ObservationType = .generalAccess, didChangeCallback: @escaping () -> Void) {
        self.observationType = observationType
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification, object: nil)
            .eraseToAnyPublisher()
            .toVoid()
            .prepend(())
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                UNUserNotificationCenter.current()
                    .getNotificationSettings { [weak self] settings in
                        DispatchQueue.main.async {
                            self?.update(with: settings)
                        }
                    }
            }
            .store(in: &cancellables)
        
        objectWillChange
            .sink(receiveValue: didChangeCallback)
            .store(in: &cancellables)
    }
    
    private func update(with settings: UNNotificationSettings) {
        let systemAccessGranted = settings.authorizationStatus == .authorized
        let soundAccessDisabled = settings.soundSetting == .disabled
        defer {
            notificationAccessTitle = observationType.title
            symbolName = observationType.symbolName
            if observationType == .generalAccess {
                isAccessGranted = systemAccessGranted
            } else {
                isAccessGranted = !soundAccessDisabled
            }
        }
        
        guard systemAccessGranted else {
            notificationAccessMessage = L10n.Settings.Reminders.NoAccess.general
            return
        }
        
        if observationType == .soundAccess && soundAccessDisabled {
            notificationAccessMessage = L10n.Settings.Reminders.NoAccess.noSound
        }
    }
    
}

struct NotificationsDisabledView: View {
    
    @StateObject var viewModel: NotificationsDisabledViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()
            
            HStack {
                Image(systemName: viewModel.symbolName)
                    .foregroundColor(Color.orange)
                Text(viewModel.notificationAccessTitle)
                    .font(Font.system(.body, design: .rounded).bold())
            }
            
            Text(viewModel.notificationAccessMessage)
                .font(Font.system(.body, design: .rounded))
            
            Divider()
            
            Button {
                guard
                    let url = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
            } label: {
                Text(L10n.Settings.Reminders.NoAccess.turnOnTitle)
                    .font(Font.system(.body, design: .rounded))
                    .foregroundColor(Color.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
    }
}

struct NotificationsDisabledView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsDisabledView(viewModel: NotificationsDisabledViewModel(didChangeCallback: {}))
            .previewLayout(.fixed(width: 350, height: 250))
    }
}
