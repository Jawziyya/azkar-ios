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
        .customScrollContentBackground()
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .navigationTitle(L10n.Settings.Counter.title)
    }
    
    var content: some View {
        Group {
            // typePicker
            
            if viewModel.preferences.counterType == .floatingButton {
                HStack {
                    Text(L10n.Settings.Counter.counterSizeTitle)
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
                            .foregroundStyle(Color.text)
                    } label: { _ in
                        Image(systemName: "info.circle")
                            .foregroundStyle(Color.accent.opacity(0.75))
                    }
                }
                .padding(.vertical, 3)
            }
        }
        .systemFont(.body)
        .foregroundStyle(Color.text)
        .onAppear {
            AnalyticsReporter.reportScreen("Settings", className: viewName)
        }
    }
    
    private var typePicker: some View {
        HStack {
            Text(L10n.Settings.Counter.counterType)
            Spacer()

            Templates.Menu {
                Text(L10n.Settings.Counter.counterTypeInfo)
                    .padding()
                    .cornerRadius(10)
            } label: { _ in
                Image(systemName: "info.circle")
                    .foregroundStyle(Color.accent.opacity(0.75))
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
