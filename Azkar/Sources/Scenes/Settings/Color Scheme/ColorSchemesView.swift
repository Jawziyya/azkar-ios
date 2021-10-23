// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Combine

final class ColorSchemesViewModel: ObservableObject {
    
    var preferences: Preferences
    
    private var cancellables = Set<AnyCancellable>()
    
    init(preferences: Preferences) {
        self.preferences = preferences
        preferences
            .storageChangesPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] in
                objectWillChange.send()
            })
            .store(in: &cancellables)
    }
    
    static var placeholder: ColorSchemesViewModel {
        ColorSchemesViewModel(preferences: Preferences())
    }
    
}

struct ColorSchemesView: View {
    
    @ObservedObject var viewModel: ColorSchemesViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ItemPickerView(
                    selection: $viewModel.preferences.theme,
                    header: L10n.Settings.Theme.colorScheme,
                    items: Theme.allCases,
                    dismissOnSelect: false
                )
                
                ItemPickerView(
                    selection: $viewModel.preferences.colorTheme,
                    header: L10n.Settings.Theme.ColorTheme.header,
                    items: ColorTheme.allCases,
                    dismissOnSelect: false
                )
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

struct ColorSchemesView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemesView(viewModel: .placeholder)
    }
}
