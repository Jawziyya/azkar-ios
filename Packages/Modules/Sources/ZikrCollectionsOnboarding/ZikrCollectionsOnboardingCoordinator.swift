import SwiftUI
import Coordinator
import Stinsen
import Library
import Entities

public enum ZikrCollectionsOnboardingRoute: Hashable, RouteKind {
    case collectionPicker
}

public final class ZikrCollectionsOnboardingCoordinator: RouteTrigger, Identifiable, NavigationCoordinatable {

    public var stack = Stinsen.NavigationStack<ZikrCollectionsOnboardingCoordinator>(initial: \.root)
    
    @Root var root = makeOnboarding
    @Route(.push) var collectionPicker = makeCollectionPicker
    
    private let preselectedCollection: ZikrCollectionSource
    private let onZikrCollectionSelect: (ZikrCollectionSource) -> Void
    
    public init(
        preselectedCollection: ZikrCollectionSource,
        onZikrCollectionSelect: @escaping (ZikrCollectionSource) -> Void
    ) {
        self.preselectedCollection = preselectedCollection
        self.onZikrCollectionSelect = onZikrCollectionSelect
    }
    
    public func makeOnboarding() -> some View {
        ZikrCollectionsOnboardingScreen(
            onShowCollectionPicker: {
                self.trigger(.collectionPicker)
            },
            onDismiss: {
                self.dismissCoordinator()
            }
        )
    }
    
    public func makeCollectionPicker() -> some View {
        ZikrCollectionsSelectionScreen(
            selectedCollection: preselectedCollection,
            onContinue: { [unowned self] source in
                self.onZikrCollectionSelect(source)
                self.dismissCoordinator()
            }
        )
    }
    
    public func trigger(_ route: ZikrCollectionsOnboardingRoute) {
        switch route {
        case .collectionPicker:
            self.route(to: \.collectionPicker)
        }
    }
    
}
