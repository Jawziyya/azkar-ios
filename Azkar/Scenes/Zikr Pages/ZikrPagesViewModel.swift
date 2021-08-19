//
//  ZikrPagesViewModel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit

struct ZikrPagesViewModel {

    unowned let router: RootRouter
    let category: ZikrCategory
    let title: String
    let azkar: [ZikrViewModel]
    let preferences: Preferences

    init(router: RootRouter, category: ZikrCategory, title: String, azkar: [ZikrViewModel], preferences: Preferences) {
        self.router = router
        self.category = category
        self.title = title
        self.preferences = preferences
        self.azkar = azkar
    }

    func navigateToZikr(_ vm: ZikrViewModel) {
        router.trigger(.zikr(vm.zikr))
    }

}
