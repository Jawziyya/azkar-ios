import SwiftUI
import Popovers
import Library

struct CounterView: View {
    
    @ObservedObject var viewModel: CounterViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                content
            }
            .applyContainerStyle()
        }
        .applyThemedToggleStyle()
        .customScrollContentBackground()
        .background(.background, ignoreSafeArea: .all)
        .navigationTitle(L10n.Settings.Counter.title)
        .animation(.smooth, value: viewModel.preferences.counterType)
    }
    
    var content: some View {
        Group {
            typePicker
            
            Divider()
            
            if viewModel.preferences.counterType == .floatingButton {
                HStack {
                    Text(L10n.Settings.Counter.CounterSize.title)
                    Spacer()
                    Picker(
                        CounterSize.allCases,
                        id: \.self,
                        selection: $viewModel.preferences.counterSize,
                        content: { size in
                            Text(size.title)
                        }
                    )
                    .pickerStyle(.segmented)
                }
                
                Divider()
                
                HStack {
                    Text(L10n.Settings.Counter.CounterPosition.title)
                    Spacer()
                    Picker(
                        CounterPosition.allCases,
                        id: \.self,
                        selection: $viewModel.preferences.counterPosition,
                        content: { size in
                            Text(size.title)
                        }
                    )
                    .pickerStyle(.segmented)
                }
                
                Divider()
            }

            Toggle(L10n.Settings.Counter.counterTicker, isOn: $viewModel.preferences.enableCounterTicker)
                .padding(.vertical, 3)

            Divider()
            
            Toggle(L10n.Settings.Counter.counterHaptics, isOn: $viewModel.preferences.enableCounterHapticFeedback)
                .padding(.vertical, 3)

            Divider()
            
            Toggle(isOn: $viewModel.preferences.enableGoToNextZikrOnCounterFinished) {
                HStack {
                    Text(L10n.Settings.Counter.goToNextDhikr)

                    Spacer()

                    Templates.Menu {
                        Text(L10n.Settings.Counter.goToNextDhikrTip)
                            .padding()
                            .cornerRadius(10)
                            .foregroundStyle(.text)
                    } label: { _ in
                        Image(systemName: "info.circle")
                            .foregroundStyle(.accent, opacity: 0.75)
                    }
                }
                .padding(.vertical, 3)
            }
        }
        .systemFont(.body)
        .foregroundStyle(.text)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    private var typePicker: some View {
        HStack {
            Text(L10n.Settings.Counter.CounterType.title)
            Spacer()

            Templates.Menu {
                Text(L10n.Settings.Counter.CounterType.info)
                    .padding()
                    .cornerRadius(10)
            } label: { _ in
                Image(systemName: "info.circle")
                    .foregroundStyle(.accent, opacity: 0.75)
            }

            Picker(
                CounterType.allCases,
                id: \.self,
                selection: $viewModel.preferences.counterType,
                content: { type in
                    Text(type.title)
                }
            )
            .pickerStyle(.segmented)
        }
        .padding(.vertical, 3)
    }
    
}

#Preview {
    CounterView(
        viewModel: CounterViewModel(
            router: .empty
        )
    )
}
