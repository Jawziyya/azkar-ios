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
    let azkar: [ZikrViewModel]
    let preferences: Preferences
    let player: Player

    init(type: ZikrCategory, azkar: [Zikr], preferences: Preferences, player: Player) {
        self.preferences = preferences
        title = type.title
        self.azkar = azkar.map(ZikrViewModel.init)
        self.player = player
    }

}
