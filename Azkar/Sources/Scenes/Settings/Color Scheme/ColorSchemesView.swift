// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Combine
import Library

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
            .sink(receiveValue: objectWillChange.send)
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
        ColorSchemesViewModel(
            preferences: Preferences.shared,
            subscribeScreenTrigger: {}
        )
    }
    
}

struct ColorSchemesView: View {
    
    @ObservedObject var viewModel: ColorSchemesViewModel
    @Environment(\.colorTheme) var colorTheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Section {
                    ItemPickerView(
                        selection: $viewModel.preferences.theme,
                        items: Theme.allCases,
                        dismissOnSelect: false
                    )
                } header: {
                    headerView(L10n.Settings.Theme.colorScheme)
                }
                 
                Section {
                    ItemPickerView(
                        selection: .init(get: {
                            viewModel.preferences.colorTheme
                        }, set: { newValue in
                            viewModel.setColorTheme(newValue)
                        }),
                        items: ColorTheme.legacyThemes,
                        dismissOnSelect: false
                    )
                } header: {
                    headerView(L10n.Settings.Theme.ColorTheme.header)
                }
                
                Section {
                    ItemPickerView(
                        selection: .init(get: {
                            viewModel.preferences.colorTheme
                        }, set: { newValue in
                            viewModel.setColorTheme(newValue)
                        }),
                        items: ColorTheme.modernThemes,
                        dismissOnSelect: false
                    )
                }
            }
        }
        .customScrollContentBackground()
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    func headerView(_ label: String) -> some View {
        Text(label)
            .systemFont(.title3, modification: .smallCaps)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(Color.secondaryText)
            .padding(.horizontal)
            .background(Color.background)
    }
    
}

#Preview("Color Schemes") {
    ColorSchemesView(viewModel: .placeholder)
}
