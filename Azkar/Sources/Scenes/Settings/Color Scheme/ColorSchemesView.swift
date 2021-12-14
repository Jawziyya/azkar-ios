// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Combine

typealias Action = () -> Void

final class ColorSchemesViewModel: ObservableObject {
    
    var preferences: Preferences
    
    private var cancellables = Set<AnyCancellable>()
    private let subscriptionManager: SubscriptionManagerType
    private let subscribeScreenTrigger: Action
    
    init(
        preferences: Preferences,
        subscriptionManager: SubscriptionManagerType = SubscriptionManagerFactory.create(),
        subscribeScreenTrigger: @escaping Action
    ) {
        self.preferences = preferences
        self.subscriptionManager = subscriptionManager
        self.subscribeScreenTrigger = subscribeScreenTrigger
        preferences
            .storageChangesPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] in
                objectWillChange.send()
            })
            .store(in: &cancellables)
    }
    
    func setColorTheme(_ theme: ColorTheme) {
        if subscriptionManager.isProUser() {
            preferences.colorTheme = theme
        } else {
            subscribeScreenTrigger()
        }
    }
    
    static var placeholder: ColorSchemesViewModel {
        ColorSchemesViewModel(preferences: Preferences.shared, subscribeScreenTrigger: {})
    }
    
}

struct ColorSchemesView: View {
    
    @ObservedObject var viewModel: ColorSchemesViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ItemPickerView(
                    selection: $viewModel.preferences.theme,
                    header: L10n.Settings.Theme.colorScheme,
                    items: Theme.allCases,
                    dismissOnSelect: false
                )
                
                ItemPickerView(
                    selection: .init(get: {
                        viewModel.preferences.colorTheme
                    }, set: { newValue in
                        viewModel.setColorTheme(newValue)
                    }),
                    header: L10n.Settings.Theme.ColorTheme.header,
                    items: ColorTheme.allCases,
                    dismissOnSelect: false
                )
            }
        }
        .horizontalPaddingForLargeScreen()
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

struct ColorSchemesView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemesView(viewModel: .placeholder)
    }
}
