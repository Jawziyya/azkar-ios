//  Copyright © 2020 Al Jawziyya. All rights reserved.

import SwiftUI
import Popovers
import Entities
import Library

extension Language: PickableItem {}

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
        
    var body: some View {
        List {
            Section {
                content
            }
            .listRowBackground(Color.contentBackground)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: viewModel.navigateToAboutAppScreen) {
                    Image(systemName: "info.circle")
                }
            }
        }
        .listStyle(.insetGrouped)
        .customScrollContentBackground()
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .navigationTitle(L10n.Settings.title)
        .removeSaturationIfNeeded()
    }
        
    var content: some View {
        Group {
            appearanceSection
            counterSection
            textSettingsSection
            remindersSection
        }
    }
    
    func getHeader(symbolName: String, title: String) -> some View {
        HStack {
            Image(systemName: symbolName)
                .font(.caption.bold())
                .aspectRatio(contentMode: .fit)
                .padding(3)
                .background(Color.accentColor.cornerRadius(4))
            Text(title)
                .font(Font.system(.caption, design: .rounded))
                .foregroundColor(Color.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
                    .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundStyle(Color.primary)
                    if let subtitle {
                        Text(subtitle)
                            .foregroundStyle(Color.secondary)
                            .font(.callout)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding(4)
        }
    }
    
    // MARK: - Appearance
    var appearanceSection: some View {
        getSectionButton(
            L10n.Settings.Theme.title,
            subtitle: L10n.Settings.Theme.subtitle,
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
