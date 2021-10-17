//
//  ZikrPagesViewModel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import Combine

struct ZikrPagesViewModel {

    unowned let router: RootRouter
    let category: ZikrCategory
    let title: String
    let azkar: [ZikrViewModel]
    let preferences: Preferences
    let selectedPage: AnyPublisher<Int, Never>

    init(router: RootRouter, category: ZikrCategory, title: String, azkar: [ZikrViewModel], preferences: Preferences, selectedPage: AnyPublisher<Int, Never>) {
        self.router = router
        self.category = category
        self.title = title
        self.preferences = preferences
        self.azkar = azkar
        self.selectedPage = selectedPage
    }

    func navigateToZikr(_ vm: ZikrViewModel, index: Int) {
        assert(Thread.isMainThread)
        router.trigger(.zikr(vm.zikr, index: index))
    }
    
    static var placeholder: ZikrPagesViewModel {
        AzkarListViewModel(
            router: RootCoordinator(
                preferences: Preferences(), deeplinker: Deeplinker(),
                player: Player(player: AppDelegate.shared.player)),
            category: .other,
            title: ZikrCategory.morning.title,
            azkar: [],
            preferences: Preferences(),
            selectedPage: PassthroughSubject<Int, Never>().eraseToAnyPublisher()
        )
    }

}
