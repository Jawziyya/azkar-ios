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
    
    func setAppTheme(_ theme: AppTheme) {
        if subscriptionManager.isProUser() || theme == .default {
            preferences.appTheme = theme
        } else {
            subscribeScreenTrigger()
        }
    }
    
    func setColorTheme(_ theme: ColorTheme) {
        if subscriptionManager.isProUser() || theme == .default {
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
    
    func isThemeProtected(_ theme: AppTheme) -> Bool {
        switch theme {
        case .default:
            return false
        default:
            return !subscriptionManager.isProUser()
        }
    }
    
    func isColorThemeProtected(_ theme: ColorTheme) -> Bool {
        switch theme {
        case .default:
            return false
        default:
            return !subscriptionManager.isProUser()
        }
    }
    
}

struct ColorSchemesView: View {
    
    @ObservedObject var viewModel: ColorSchemesViewModel
    @Environment(\.appTheme) var appTheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Section {
                    ItemPickerView(
                        selection: $viewModel.preferences.theme,
                        items: Theme.allCases,
                        dismissOnSelect: false
                    )
                } footer: {
                    footerView(viewModel.preferences.theme.description)
                }
                
                Section {
                    ItemPickerView(
                        selection: .init(get: {
                            viewModel.preferences.appTheme
                        }, set: { newValue in
                            viewModel.setAppTheme(newValue)
                        }),
                        items: AppTheme.enabledThemes,
                        dismissOnSelect: false,
                        isItemProtected: viewModel.isThemeProtected(_:)
                    )
                } header: {
                    headerView(L10n.Settings.Appearance.ColorTheme.header)
                }
                 
                Section {
                    ItemPickerView(
                        selection: .init(get: {
                            viewModel.preferences.colorTheme
                        }, set: { newValue in
                            viewModel.setColorTheme(newValue)
                        }),
                        items: ColorTheme.allCases,
                        dismissOnSelect: false,
                        isItemProtected: viewModel.isColorThemeProtected(_:)
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
        HeaderView(title: label)
    }
    
    func footerView(_ label: String) -> some View {
        Text(label)
            .systemFont(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(Color.secondaryText)
            .padding(.horizontal)
            .background(Color.background)
            .padding(.horizontal)
            .padding(.bottom)
    }
    
}

#Preview("Color Schemes") {
    ColorSchemesView(viewModel: .placeholder)
}
