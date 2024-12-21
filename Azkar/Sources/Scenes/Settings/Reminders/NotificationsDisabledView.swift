// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Combine

final class NotificationsDisabledViewModel: ObservableObject {
    
    @Published private(set) var notificationAccessTitle = ""
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
        NotificationsHandler
            .shared
            .notificationsPermissionStatePublisher
            .receive(on: RunLoop.main)
            .sink { [unowned self] settings in
                self.update(with: settings)
            }
            .store(in: &cancellables)
        
        objectWillChange
            .sink(receiveValue: didChangeCallback)
            .store(in: &cancellables)
    }
    
    private func update(with settings: NotificationsHandler.NotificationsPermissionState) {
        
        if settings.hasAccess {
            
            switch settings {
                
            case .noSound where observationType == .soundAccess:
                notificationAccessTitle = ObservationType.soundAccess.title
                symbolName = ObservationType.soundAccess.symbolName
                isAccessGranted = false
                
            default:
                isAccessGranted = true
                
            }
            
        } else {
            isAccessGranted = false
            notificationAccessTitle = ObservationType.generalAccess.title
            symbolName = ObservationType.generalAccess.symbolName
        }
    }
    
}

struct NotificationsDisabledView: View {
    
    @StateObject var viewModel: NotificationsDisabledViewModel
    @Environment(\.colorTheme) var colorTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: viewModel.symbolName)
                    .foregroundStyle(Color.orange)
                Text(viewModel.notificationAccessTitle)
                    .systemFont(.body, weight: .bold)
            }
            
            Divider()
            
            Button {
                guard
                    let url = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
            } label: {
                Text(L10n.Settings.Reminders.NoAccess.turnOnTitle)
                    .systemFont(.body)
                    .foregroundStyle(Color.accent)
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
