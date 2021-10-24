// Copyright © 2021 Al Jawziyya. All rights reserved. 

import UIKit
import SwiftUI
import Combine

final class NavigationController: UINavigationController {
    
    private let preferences = Preferences()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferences.$colorTheme
            .receive(on: RunLoop.main)
            .prepend(preferences.colorTheme)
            .sink(receiveValue: { [unowned self] theme in
                navigationBar.tintColor = UIColor(Color.accent)
            })
            .store(in: &cancellables)
    }
    
}
