// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI
import Popovers

struct CounterView: View {
    
    @ObservedObject var viewModel: CounterViewModel
    
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
            HStack {
                Text(L10n.Settings.Counter.counterType)
                Spacer()

                Templates.Menu {
                    Text(L10n.Settings.Counter.counterTypeInfo)
                        .padding()
                } label: { _ in
                    Image(systemName: "info.circle")
                        .foregroundColor(Color.accent.opacity(0.75))
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
            }

            Toggle(L10n.Settings.Counter.counterTicker, isOn: $viewModel.preferences.enableCounterTicker)
                .padding(.vertical, 3)

            Toggle(L10n.Settings.Counter.counterHaptics, isOn: $viewModel.preferences.enableCounterHapticFeedback)
                .padding(.vertical, 3)

            Toggle(isOn: $viewModel.preferences.enableGoToNextZikrOnCounterFinished) {
                HStack {
                    Text(L10n.Settings.Counter.goToNextDhikr)
                        .font(Font.system(.body, design: .rounded))

                    Spacer()

                    Templates.Menu {
                        Text(L10n.Settings.Counter.goToNextDhikrTip)
                    } label: { _ in
                        Image(systemName: "info.circle")
                            .foregroundColor(Color.accent.opacity(0.75))
                    }
                }
                .padding(.vertical, 3)
            }
        }
    }
    
}

#Preview {
    CounterView(
        viewModel: CounterViewModel(
            router: .empty
        )
    )
}
