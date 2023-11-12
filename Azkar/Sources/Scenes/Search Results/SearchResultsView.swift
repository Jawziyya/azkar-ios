import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var viewModel: SearchResultsViewModel
    var onSelect: (SearchResult) -> Void

    var body: some View {
        content
            .customScrollContentBackground()
            .background(Color.background, ignoresSafeAreaEdges: .all)
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.isPerformingSearch {
            ProgressView()
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
            ForEach(viewModel.sections) { section in
                if !section.results.isEmpty {
                    Section(header: section.title) {
                        ForEach(section.results, content: searchResultView)
                    }
                }
            }
        }
    }
    
    func searchResultView(for result: SearchResult) -> some View {
        Button {
            onSelect(result)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                if let title = result.title {
                    Text(title)
                        .font(Font.headline)
                }
                Text(result.text)
            }
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
