//
//
//  Azkar
//  
//  Created on 18.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import SwiftUI
import Combine

final class Deeplinker: ObservableObject {

    @Published var route: Route?

    enum Route: Equatable, Hashable {
        case settings(SettingsSection)
        case azkar(ZikrCategory)
    }
}

struct RouteKey: EnvironmentKey {
    static var defaultValue: Deeplinker.Route? {
        return nil
    }
}
extension EnvironmentValues {
    var route: Deeplinker.Route? {
        get {
            self[RouteKey]
        }
        set {
            self[RouteKey] = newValue
        }
    }
}
