// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation

public protocol RouteKind {}

public protocol RouteTrigger: AnyObject {
    associatedtype RouteType: RouteKind
    func trigger(_ route: RouteType)
}

private final class EmptyRouteTrigger<T: RouteKind>: RouteTrigger {
    func trigger(_ route: T) {}
}

public final class UnownedRouteTrigger<RouteType: RouteKind>: RouteTrigger {
    private unowned let router: AnyObject
    private let triggerFunc: (RouteType) -> Void

    public init<T: RouteTrigger>(router: T) where T.RouteType == RouteType {
        self.router = router
        self.triggerFunc = router.trigger
    }

    public func trigger(_ route: RouteType) {
        triggerFunc(route)
    }
    
    public static var empty: UnownedRouteTrigger<RouteType> {
        UnownedRouteTrigger(router: EmptyRouteTrigger())
    }
}
