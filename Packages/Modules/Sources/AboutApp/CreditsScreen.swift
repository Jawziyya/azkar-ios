import SwiftUI
import Library

public struct CreditsScreen: View {
    
    let viewModel: CreditsViewModel
    @Environment(\.safariPresenter) var safariPresenter
    
    public init(viewModel: CreditsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section {
                    ForEach(section.items) { item in
                        viewForItem(item)
                            .listRowBackground(Color.contentBackground)
                    }
                } header: {
                    sectionHeader(section)
                }
            }
        }
        .customScrollContentBackground()
        .background(Color.background, ignoresSafeAreaEdges: .all)
        .listStyle(.grouped)
        .navigationBarTitle("credits.title")
        .removeSaturationIfNeeded()
    }
    
    private func sectionHeader(_ section: SourceInfo.Section) -> some View {
        Text(section.title)
            .foregroundStyle(Color.text)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func viewForItem(_ item: SourceInfo.Item) -> some View {
        Button(action: {
            safariPresenter.set(URL(string: item.link))
        }, label: {
            HStack {
                Text(item.title)
                    .foregroundStyle(Color.text)
                Spacer()
                Image(systemName: "arrow.up.forward")
                    .foregroundStyle(Color.tertiaryText)
            }
            .background(Color.contentBackground)
            .clipShape(Rectangle())
        })
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
    
}

#Preview {
    CreditsScreen(
        viewModel: CreditsViewModel()
    )
}
