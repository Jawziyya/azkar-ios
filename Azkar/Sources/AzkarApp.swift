// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI
import Library
import Entities
import AudioPlayer
import Stinsen

@main
struct AzkarApp: App {
    
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    @StateObject var preferences = Preferences.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationViewCoordinator(
                RootCoordinator(
                    preferences: Preferences.shared,
                    deeplinker: Deeplinker(),
                    player: Player(player: AudioPlayer())
                )
            )
            .view()
            .tint(Color.accent)
            .toggleStyle(SwitchToggleStyle(tint: Color.accent))
            .onReceive(preferences.$theme) { theme in
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let window = scene?.keyWindow
                window?.overrideUserInterfaceStyle = theme.userInterfaceStyle
            }
        }
    }
    
}
