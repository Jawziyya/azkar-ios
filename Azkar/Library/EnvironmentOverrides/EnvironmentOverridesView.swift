import SwiftUI
import Combine

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
            .environment(\.sizeCategory, viewModel.preferences.useSystemFontSize ? defaultSizeCategory : viewModel.preferences.sizeCategory)
    }
    
    private func copyDefaultSettings() {
        if viewModel.preferences.useSystemFontSize {
            viewModel.preferences.sizeCategory = defaultSizeCategory
        }
    }
    
}
