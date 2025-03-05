//  Copyright © 2020 Al Jawziyya. All rights reserved.

import SwiftUI
import Popovers
import Entities
import Library

extension Language: PickableItem {}

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    @Environment(\.appTheme) var appTheme
        
    var body: some View {
        ScrollView {
            VStack {
                content
            }
            .applyContainerStyle()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.navigateToAboutAppScreen) {
                    Image(systemName: "info.circle")
                }
            }
        }
        .customScrollContentBackground()
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .navigationTitle(L10n.Settings.title)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
        
    var content: some View {
        Group {
            appearanceSection
            Divider()
            counterSection
            Divider()
            textSettingsSection
            Divider()
            remindersSection
        }
    }
        
    func getSectionButton(
        _ title: String,
        subtitle: String?,
        image: String,
        imageBackground: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 21, height: 21)
                    .font(.body)
                    .padding(7)
                    .foregroundStyle(Color.white)
                    .background(imageBackground)
                    .cornerRadius(appTheme.cornerRadius > 0 ? 8 : 0)
                    .removeSaturationIfNeeded()
                
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundStyle(Color.text)
                        .systemFont(.body)
                    if let subtitle {
                        Text(subtitle)
                            .foregroundStyle(Color.secondaryText)
                            .systemFont(.callout)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding(4)
            .multilineTextAlignment(.leading)
        }
    }
    
    // MARK: - Appearance
    var appearanceSection: some View {
        getSectionButton(
            L10n.Settings.Appearance.title,
            subtitle: L10n.Settings.Appearance.subtitle,
            image: "paintbrush.fill",
            imageBackground: Color(.systemTeal),
            action: viewModel.navigateToAppearanceSettings
        )
    }
    
    var counterSection: some View {
        getSectionButton(
            L10n.Settings.Counter.title,
            subtitle: L10n.Settings.Counter.subtitle,
            image: "arrow.counterclockwise",
            imageBackground: Color(.systemIndigo),
            action: viewModel.navigateToCounterSettings
        )
    }
    
    // MARK: - Content Size
    var textSettingsSection: some View {
        getSectionButton(
            L10n.Settings.Text.title,
            subtitle: L10n.Settings.Text.subtitle,
            image: "bold.italic.underline",
            imageBackground: Color(.systemBlue),
            action: viewModel.navigateToTextSettings
        )
    }
    
    var remindersSection: some View {
        getSectionButton(
            L10n.Settings.Reminders.title,
            subtitle: L10n.Settings.Reminders.subtitle,
            image: "bell.fill",
            imageBackground: Color(.systemGreen),
            action: viewModel.navigateToRemindersSettings
        )
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(
                viewModel: SettingsViewModel(
                    databaseService: AzkarDatabase(language: .english),
                    preferences: Preferences.shared,
                    router: .empty
                )
            )
        }
    }
    
}
