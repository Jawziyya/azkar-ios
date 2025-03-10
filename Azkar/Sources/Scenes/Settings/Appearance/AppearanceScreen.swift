import SwiftUI
import Popovers
import Library

struct AppearanceScreen: View {
    
    @ObservedObject var viewModel: AppearanceViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                content
            }
            .applyContainerStyle()
        }
        .customScrollContentBackground()
        .background(.background, ignoreSafeArea: .all)
        .navigationTitle(L10n.Settings.Appearance.title)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    var content: some View {
        Group {
            PickerView(
                label: L10n.Settings.Appearance.AppTheme.title,
                subtitle: viewModel.themeTitle,
                destination: themePicker
            )
            
            Divider()

            if viewModel.canChangeIcon {
                PickerView(
                    label: L10n.Settings.Icon.title,
                    subtitle: viewModel.preferences.appIcon.title,
                    destination: iconPicker
                )
                
                Divider()
            }

            Toggle(isOn: $viewModel.preferences.enableFunFeatures) {
                HStack {
                    Text(L10n.Settings.useFunFeatures)
                        .systemFont(.body)
                        .foregroundStyle(.text)
                    Spacer()
                    
                    Templates.Menu {
                        Text(L10n.Settings.useFunFeaturesTip)
                            .padding()
                            .cornerRadius(10)
                    } label: { _ in
                        Image(systemName: "info.circle")
                            .foregroundStyle(.accent, opacity: 0.75)
                    }
                }
                .padding(.vertical, 8)
            }
            .applyThemedToggleStyle()
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
