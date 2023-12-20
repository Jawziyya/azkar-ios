import SwiftUI

struct SearchResultsView: View {
    
    @ObservedObject var viewModel: SearchResultsViewModel
    var onSelect: (SearchResultZikr) -> Void

    var body: some View {
        content
            .customScrollContentBackground()
            .background(Color.background, ignoresSafeAreaEdges: .all)
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.isPerformingSearch {
            ProgressView()
                .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.haveSearchResults == false {
            Text(L10n.Common.noSearchResults)
                .font(.title3)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(Color.secondary)
                .padding()
        } else {
            searchResultsList
        }
    }
    
    var searchResultsList: some View {
        List {
            ForEach(viewModel.searchResults) { section in
                Section {
                    ForEach(section.results, content: searchResultView)
                } header: {
                    HStack {
                        if let image = section.image {
                            Image(systemName: image)
                        }
                        if let title = section.title {
                            Text(title)
                        }
                    }
                }
            }
        }
    }
    
    func searchResultView(for result: SearchResultZikr) -> some View {
        Button {
            onSelect(result)
        } label: {
            SearchResultsItemView(result: result)
                .padding(.vertical, 6)
                .foregroundStyle(Color.text)
        }
    }
    
}

#Preview("Search Results") {
    NavigationView {
        SearchResultsView(
            viewModel: SearchResultsViewModel.placeholder,
            onSelect: { _ in }
        )
    }
}
