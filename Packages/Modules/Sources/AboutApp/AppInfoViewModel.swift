//  Copyright © 2020 Al Jawziyya. All rights reserved.

import UIKit
import Combine
import SwiftUI

public final class AppInfoViewModel: ObservableObject {

    let appVersion: String
    let isProUser: Bool
    @Published private(set) var iconImageName: String = "azkar-gold-logo"

    private var cancellables = Set<AnyCancellable>()

    public init(
        appVersion: String,
        isProUser: Bool
    ) {
        self.appVersion = appVersion
        self.isProUser = isProUser
    }
        
}
