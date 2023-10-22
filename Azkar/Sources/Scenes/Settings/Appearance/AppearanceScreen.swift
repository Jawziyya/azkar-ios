// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI
import Popovers

struct AppearanceScreen: View {
    
    @ObservedObject var viewModel: AppearanceViewModel
    
    var body: some View {
        List {
            content
                .listRowBackground(Color.contentBackground)
        }
        .customScrollContentBackground()
        .background(Color.background, ignoresSafeAreaEdges: .all)
    }
    
    var content: some View {
        Group {
            PickerView(
                label: L10n.Settings.Theme.themesTitle,
                subtitle: viewModel.themeTitle,
                destination: themePicker
            )

            if viewModel.canChangeIcon {
                PickerView(
                    label: L10n.Settings.Icon.title,
                    subtitle: viewModel.preferences.appIcon.title,
                    destination: iconPicker
                )
            }

            Toggle(isOn: $viewModel.preferences.enableFunFeatures) {
                HStack {
                    Text(L10n.Settings.useFunFeatures)
                        .font(Font.system(.body, design: .rounded))
                    Spacer()
                    
                    Templates.Menu {
                        Text(L10n.Settings.useFunFeaturesTip)
                    } label: { _ in
                        Image(systemName: "info.circle")
                            .foregroundColor(Color.accent.opacity(0.75))
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    var themePicker: some View {
        ColorSchemesView(viewModel: viewModel.colorSchemeViewModel)
    }

    var iconPicker: some View {
        AppIconPackListView(viewModel: viewModel.appIconPackListViewModel)
    }
    
}

#Preview("Appearance View") {
    NavigationView {
        AppearanceScreen(
            viewModel: AppearanceViewModel(
                router: .empty
            )
        )
    }
}
