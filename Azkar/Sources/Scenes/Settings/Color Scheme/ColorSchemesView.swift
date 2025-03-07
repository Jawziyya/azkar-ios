// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Combine
import Library

final class ColorSchemesViewModel: ObservableObject {
    
    var preferences: Preferences
    
    private var cancellables = Set<AnyCancellable>()
    let subscriptionManager: SubscriptionManagerType
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
    
    func setThemes(appTheme: AppTheme, colorTheme: ColorTheme) {
        guard subscriptionManager.isProUser() || (isThemeProtected(appTheme) == false && isColorThemeProtected(colorTheme) == false) else {
            subscribeScreenTrigger()
            return
        }
        preferences.appTheme = appTheme
        preferences.colorTheme = colorTheme
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
    
    @State var selectedAppTheme: AppTheme
    @State var selectedColorTheme: ColorTheme
    
    init(
        viewModel: ColorSchemesViewModel
    ) {
        self.viewModel = viewModel
        selectedAppTheme = viewModel.preferences.appTheme
        selectedColorTheme = viewModel.preferences.colorTheme
    }
    
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
                            selectedAppTheme
                        }, set: { newValue in
                            if viewModel.isThemeProtected(newValue) == false {
                                viewModel.setAppTheme(newValue)
                            }
                            selectedAppTheme = newValue
                        }),
                        items: AppTheme.enabledThemes,
                        dismissOnSelect: false,
                        isItemProtected: { _ in false }
                    )
                } header: {
                    headerView(L10n.Settings.Appearance.ColorTheme.header)
                }
                 
                Section {
                    ItemPickerView(
                        selection: .init(get: {
                            selectedColorTheme
                        }, set: { newValue in
                            if viewModel.isColorThemeProtected(newValue) == false {
                                viewModel.setColorTheme(newValue)
                            }
                            selectedColorTheme = newValue
                        }),
                        items: ColorTheme.allCases,
                        dismissOnSelect: false,
                        isItemProtected: { _ in false }
                    )
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if themeChanged && viewModel.subscriptionManager.isProUser() == false {
                    Button(action: {
                        viewModel.setThemes(appTheme: selectedAppTheme, colorTheme: selectedColorTheme)
                    }, label: {
                        HStack {
                            if viewModel.subscriptionManager.isProUser() == false && isProItemSelected {
                                Image(systemName: "lock.fill")
                            }
                            Text(L10n.Common.done)
                        }
                    })
                    .transition(.opacity)
                    .buttonStyle(.borderedProminent)
                    .animation(.smooth, value: selectedAppTheme.hashValue ^ selectedColorTheme.hashValue)
                }
            }
        }
        .customScrollContentBackground()
        .background(.background, ignoreSafeArea: .all)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
        .environment(\.appTheme, selectedAppTheme)
        .environment(\.colorTheme, selectedColorTheme)
    }
    
    private var isProItemSelected: Bool {
        selectedAppTheme != .default || selectedColorTheme != .default
    }
    
    private var themeChanged: Bool {
        selectedAppTheme != viewModel.preferences.appTheme || selectedColorTheme != viewModel.preferences.colorTheme
    }
    
    func headerView(_ label: String) -> some View {
        HeaderView(title: label)
    }
    
    func footerView(_ label: String) -> some View {
        Text(label)
            .systemFont(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.secondaryText)
            .padding(.horizontal)
            .background(.background)
            .padding(.horizontal)
            .padding(.bottom)
    }
    
}

#Preview("Color Schemes") {
    ColorSchemesView(viewModel: .placeholder)
}
