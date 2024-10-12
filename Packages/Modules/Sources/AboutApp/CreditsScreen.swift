import SwiftUI
import Library

public struct CreditsScreen: View {
    
    let viewModel: CreditsViewModel
    
    public init(viewModel: CreditsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section {
                    ForEach(section.items) { item in
                        viewForItem(item)
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
            if let url = URL(string: item.link) {
                UIApplication.shared.open(url)
            }
        }, label: {
            HStack {
                Text(item.title)
                    .foregroundColor(Color.text)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.tertiaryText)
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
