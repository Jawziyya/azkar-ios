//
//  Preferences.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 03.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation
import Combine

final class Preferences: ObservableObject {

    @Preference(Keys.expandTranslation, defaultValue: true)
    var expandTranslation: Bool

    @Preference(Keys.expandTransliteration, defaultValue: true)
    var expandTransliteration: Bool

    @Preference(Keys.arabicFont, defaultValue: .KFGQP)
    var arabicFont: ArabicFont

    @Preference(Keys.theme, defaultValue: .automatic)
    var theme: Theme

    private var notificationSubscription: AnyCancellable?

    init() {
        notificationSubscription = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .sink { _ in
                self.objectWillChange.send()
            }
    }
    
}
