// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI
import Combine

/// Base view model which sends update signal on any preferneces changes.
class PreferencesDependantViewModel: ObservableObject {
    var preferences: Preferences
    private var cancellables = Set<AnyCancellable>()
    init(preferences: Preferences) {
        self.preferences = preferences
        preferences
            .storageChangesPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellables)
    }
}
