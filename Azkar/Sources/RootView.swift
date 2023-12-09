import SwiftUI
import Combine

final class RootViewModel: ObservableObject {
    var mainMenuViewModel: MainMenuViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @Published var title = ""
    
    private func getRandomEmoji() -> String {
        ["🌙", "🌸", "☘️", "🌳", "🌴", "🌱", "🌼", "💫", "🌎", "🌍", "🌏", "🪐", "✨", "❄️"].randomElement()!
    }
    
    init(
        mainMenuViewModel: MainMenuViewModel
    ) {
        self.mainMenuViewModel = mainMenuViewModel
        mainMenuViewModel.objectWillChange
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellables)
        
        let appName = L10n.appName
        let title = "\(appName)"
        mainMenuViewModel.preferences
            .$enableFunFeatures
            .map { [unowned self] flag in
                if flag {
                    return title + " \(self.getRandomEmoji())"
                } else {
                    return title
                }
            }
            .assign(to: \.title, on: self)
            .store(in: &cancellables)
    }
}

struct RootView: View {
    
    @ObservedObject var viewModel: RootViewModel
    
    var body: some View {
        MainMenuView(
            viewModel: viewModel.mainMenuViewModel
        )
        .navigationBarTitle(viewModel.title)
        .navigationTitleMode(.large)
        .searchable(
            text: $viewModel.mainMenuViewModel.searchQuery,
            placement: .navigationBarDrawer(displayMode: .always)
        )
    }
}

#Preview("Root View") {
    NavigationView {
        RootView(
            viewModel: .init(mainMenuViewModel: .placeholder)
        )
    }
}
