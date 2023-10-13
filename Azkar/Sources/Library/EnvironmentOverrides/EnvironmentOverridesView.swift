import SwiftUI
import Combine
import Extensions

extension ContentSizeCategory: Comparable {}

extension EnvironmentValues {
    struct Diff: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let colorScheme = Diff(rawValue: 1 << 1)
        public static let sizeCategory = Diff(rawValue: 1 << 2)
    }
}

extension View {
    func attachEnvironmentOverrides(viewModel: EnvironmentOverridesViewModel, onChange: ((EnvironmentValues.Diff) -> Void)? = nil) -> some View {
        modifier(EnvironmentOverridesModifier(viewModel: viewModel, onChange: onChange))
    }
}

final class EnvironmentOverridesViewModel: ObservableObject {
    @Published var preferences: Preferences
    var objectWillChange = PassthroughSubject<Void, Never>()

    private var cancellabels = Set<AnyCancellable>()

    init(preferences: Preferences) {
        self.preferences = preferences
        preferences
            .storageChangesPublisher()
            .receive(on: RunLoop.main)
            .subscribe(objectWillChange)
            .store(in: &cancellabels)
    }
}

struct EnvironmentOverridesModifier: ViewModifier {

    @ObservedObject var viewModel: EnvironmentOverridesViewModel

    @Environment(\.sizeCategory) private var defaultSizeCategory: ContentSizeCategory
    let onChange: ((EnvironmentValues.Diff) -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear { self.copyDefaultSettings() }
    }

    private var contentSizeCategory: ContentSizeCategory {
        if viewModel.preferences.useSystemFontSize {
            let smallestAvailableContentSize = ContentSizeCategory.availableCases.first!
            let biggestAvailableContentSize = ContentSizeCategory.availableCases.last!
            return max(smallestAvailableContentSize, min(biggestAvailableContentSize, defaultSizeCategory))
        } else {
            return viewModel.preferences.sizeCategory
        }
    }
    
    private func copyDefaultSettings() {
        if viewModel.preferences.useSystemFontSize {
            viewModel.preferences.sizeCategory = defaultSizeCategory
        }
    }
    
}
