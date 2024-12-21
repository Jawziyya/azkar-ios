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
    @State var colorTheme: ColorTheme = ColorTheme.current
    
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
            .id(colorTheme)
            .tint(Color.accent)
            .toggleStyle(SwitchToggleStyle(tint: Color.accent))
            .onReceive(preferences.$colorTheme) { newTheme in
                setNavigationBarFont(theme: newTheme)
                colorTheme = newTheme
            }
            .onReceive(preferences.$theme) { theme in
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let window = scene?.keyWindow
                window?.overrideUserInterfaceStyle = theme.userInterfaceStyle
            }
            .environment(\.colorTheme, preferences.colorTheme)
        }
    }
    
    private func setNavigationBarFont(theme: ColorTheme) {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithOpaqueBackground()
        
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
                
        let fontDesign: UIFontDescriptor.SystemDesign
        switch theme.fontDesign {
        case .monospaced: fontDesign = .monospaced
        case .rounded: fontDesign = .rounded
        case .serif: fontDesign = .serif
        default: fontDesign = .default
        }
        
        let largeTitleTextAttributes = [
            NSAttributedString.Key.font: getSystemFont(style: .largeTitle, design: fontDesign),
            .foregroundColor: UIColor(Color.text)
        ]
        let titleTextAttributes = [
            NSAttributedString.Key.font: getSystemFont(style: .title3, design: fontDesign),
            .foregroundColor: UIColor(Color.text)
        ]
        
        standardAppearance.titleTextAttributes = titleTextAttributes
        standardAppearance.largeTitleTextAttributes = largeTitleTextAttributes
        standardAppearance.backgroundColor = UIColor(Color.background)
        
        scrollEdgeAppearance.titleTextAttributes = titleTextAttributes
        scrollEdgeAppearance.largeTitleTextAttributes = largeTitleTextAttributes
        scrollEdgeAppearance.backgroundColor = UIColor(Color.background)
        
        UINavigationBar.appearance().standardAppearance = standardAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = scrollEdgeAppearance
        UINavigationBar.appearance().tintColor = UIColor(Color.text)
    }
    
    private func getSystemFont(style: UIFont.TextStyle, design: UIFontDescriptor.SystemDesign) -> UIFont {
        let systemFont = UIFont.preferredFont(forTextStyle: style)
        let font: UIFont
        if let descriptor = systemFont.fontDescriptor.withDesign(design) {
            font = UIFont(descriptor: descriptor, size: systemFont.pointSize)
        } else {
            font = systemFont
        }
        return font
    }
    
}
