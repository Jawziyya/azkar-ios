// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation

protocol Route {}

protocol RouteTrigger: AnyObject {
    associatedtype RouteType: Route
    func trigger(_ route: RouteType)
}

final class EmptyRouteTrigger<T: Route>: RouteTrigger {
    func trigger(_ route: T) {}
}

final class UnownedRouteTrigger<RouteType: Route>: RouteTrigger {
    private unowned let router: AnyObject
    private let triggerFunc: (RouteType) -> Void

    init<T: RouteTrigger>(router: T) where T.RouteType == RouteType {
        self.router = router
        self.triggerFunc = router.trigger
    }

    func trigger(_ route: RouteType) {
        triggerFunc(route)
    }
    
    static var empty: UnownedRouteTrigger<RouteType> {
        UnownedRouteTrigger(router: EmptyRouteTrigger())
    }
}
