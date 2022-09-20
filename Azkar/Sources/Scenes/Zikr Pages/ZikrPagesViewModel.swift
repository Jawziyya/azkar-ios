//
//  ZikrPagesViewModel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import Combine

final class ZikrPagesViewModel: ObservableObject, Equatable {

    static func == (lhs: ZikrPagesViewModel, rhs: ZikrPagesViewModel) -> Bool {
        lhs.category == rhs.category && lhs.title == rhs.title
    }

    unowned let router: RootRouter
    let category: ZikrCategory
    let title: String
    let azkar: [ZikrViewModel]
    let preferences: Preferences
    let selectedPage: AnyPublisher<Int, Never>
    let canUseCounter: Bool
    @Published var page = 0
    @Published var currentZikrRemainingRepeatNumber = 0

    private var incrementerPublishers: [ZikrViewModel: PassthroughSubject<Void, Never>] = [:]

    let alignZikrCounterByLeadingSide: Bool

    var showCounterButton: Bool {
        preferences.counterType == .floatingButton
    }

    private var cancellables = Set<AnyCancellable>()

    init(
        router: RootRouter,
        category: ZikrCategory,
        title: String,
        azkar: [ZikrViewModel],
        preferences: Preferences,
        selectedPagePublisher: AnyPublisher<Int, Never>,
        page: Int = 0
    ) {
        self.router = router
        self.category = category
        self.title = title
        self.preferences = preferences
        self.azkar = azkar
        self.selectedPage = selectedPagePublisher
        self.page = page
        canUseCounter = category == .morning || category == .evening

        alignZikrCounterByLeadingSide = preferences.alignCounterButtonByLeadingSide

        azkar.forEach { vm in
            incrementerPublishers[vm] = PassthroughSubject<Void, Never>()
        }

        $page
            .map { [unowned self] page in
                guard page < self.azkar.count else {
                    return 0
                }
                let zikr = self.azkar[page]
                return zikr.remainingRepeatsNumber
            }
            .assign(to: &$currentZikrRemainingRepeatNumber)

        preferences
            .$counterType
            .toVoid()
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellables)
        
        selectedPagePublisher.assign(to: &$page)
    }

    func navigateToZikr(_ vm: ZikrViewModel, index: Int) {
        if UIDevice.current.isIpadInterface {
            router.trigger(.zikr(vm.zikr, index: index))
        } else {
            router.trigger(.zikrPages(.init(router: router, category: category, title: title, azkar: azkar, preferences: preferences, selectedPagePublisher: selectedPage.eraseToAnyPublisher()), page: index))
        }
    }
    
    func navigateToSettings() {
        router.trigger(.modalSettings(.textAndAppearance))
    }

    func goToNextZikrIfNeeded() {
        let newIndex = page + 1
        guard preferences.enableGoToNextZikrOnCounterFinished, newIndex < azkar.count else {
            return
        }
        router.trigger(.goToPage(newIndex))
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

    func setZikrCounterAlignment(byLeftSide flag: Bool) {
        preferences.alignCounterButtonByLeadingSide = flag
    }

    func incrementCurrentPageZikrCounter() {
        let zikr = azkar[page]
        incrementerPublishers[zikr]?.send()
        let number = zikr.remainingRepeatsNumber - 1
        currentZikrRemainingRepeatNumber = number
    }

    func getIncrementPublisher(for zikr: ZikrViewModel) -> AnyPublisher<Void, Never> {
        if let publisher = incrementerPublishers[zikr] {
            return publisher.eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }

}
