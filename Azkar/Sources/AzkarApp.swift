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
        }
    }
    
}
