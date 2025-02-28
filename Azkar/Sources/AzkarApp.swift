// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI
import Library
import Entities
import AudioPlayer
import Stinsen
import StoreKit

@main
struct AzkarApp: App {
    
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    let preferences = Preferences.shared
    
    init() {
        #if !DEBUG
        requestAppReview()
        #endif
    }
    
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
            .onReceive(preferences.$appTheme) { newTheme in
                setNavigationBarFont(theme: newTheme, colorTheme: preferences.colorTheme)
            }
            .onReceive(preferences.$colorTheme) { colorTheme in
                setNavigationBarFont(theme: preferences.appTheme, colorTheme: colorTheme)
            }
            .onReceive(preferences.$theme) { theme in
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let window = scene?.keyWindow
                window?.overrideUserInterfaceStyle = theme.userInterfaceStyle
            }
            .connectAppTheme()
        }
    }
    
    private func setNavigationBarFont(theme: AppTheme, colorTheme: ColorTheme) {
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

        // Apply appearance to all existing navigation controllers
        if let scenes = UIApplication.shared.connectedScenes as? Set<UIWindowScene> {
            scenes.forEach { scene in
                scene.windows.forEach { window in
                    window.rootViewController?.allChildViewControllers.forEach { viewController in
                        if let navigationController = viewController as? UINavigationController {
                            navigationController.navigationBar.standardAppearance = standardAppearance
                            navigationController.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
                            navigationController.navigationBar.tintColor = UIColor(Color.text)
                        }
                    }
                }
            }
        }
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
    
    private func requestAppReview() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let windowScene = UIApplication.shared.connectedScenes.first?.session.scene as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
    
}

// Extension to get all child view controllers recursively
extension UIViewController {
    var allChildViewControllers: [UIViewController] {
        var all = [self]
        for child in children {
            all.append(contentsOf: child.allChildViewControllers)
        }
        return all
    }
}
