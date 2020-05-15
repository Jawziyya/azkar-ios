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

    init(title: String, azkar: [ZikrViewModel], preferences: Preferences) {
        self.title = title
        self.preferences = preferences
        self.azkar = azkar
    }

}
