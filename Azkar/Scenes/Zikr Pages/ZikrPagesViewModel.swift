//
//  ZikrPagesViewModel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation

struct ZikrPagesViewModel {

    let title: String
    let azkar: [Zikr]
    let player: Player
    let preferences: Preferences

    init(type: ZikrCategory, azkar: [Zikr], player: Player, preferences: Preferences) {
        self.preferences = preferences
        title = type.title
        self.azkar = azkar
        self.player = player
    }

}
