//
//  ZikrPagesViewModel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import Combine

final class ZikrPagesViewModel: ObservableObject {

    unowned let router: RootRouter
    let category: ZikrCategory
    let title: String
    let azkar: [ZikrViewModel]
    let preferences: Preferences
    let selectedPage: AnyPublisher<Int, Never>
    @Published var page = 0

    init(router: RootRouter, category: ZikrCategory, title: String, azkar: [ZikrViewModel], preferences: Preferences, selectedPagePublisher: AnyPublisher<Int, Never>, page: Int = 0) {
        self.router = router
        self.category = category
        self.title = title
        self.preferences = preferences
        self.azkar = azkar
        self.selectedPage = selectedPagePublisher
        self.page = page
    }

    func navigateToZikr(_ vm: ZikrViewModel, index: Int) {
        assert(Thread.isMainThread)
        router.trigger(.zikr(vm.zikr, index: index))
    }
    
    func navigateToSettings() {
        router.trigger(.modalSettings(.textAndAppearance))
    }
    
    static var placeholder: ZikrPagesViewModel {
        AzkarListViewModel(
            router: RootCoordinator(
                preferences: Preferences.shared, deeplinker: Deeplinker(),
                player: Player(player: AppDelegate.shared.player)),
            category: .other,
            title: ZikrCategory.morning.title,
            azkar: [],
            preferences: Preferences.shared,
            selectedPagePublisher: PassthroughSubject<Int, Never>().eraseToAnyPublisher()
        )
    }

}
