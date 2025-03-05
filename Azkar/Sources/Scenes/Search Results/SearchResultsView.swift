import SwiftUI
import Extensions

struct SearchResultsView: View {
    
    @Environment(\.appTheme) var appTheme
    @ObservedObject var viewModel: SearchResultsViewModel
    var onSelect: (SearchResultZikr) -> Void

    var body: some View {
        content
            .customScrollContentBackground()
            .background(Color.background, ignoresSafeAreaEdges: .all)
            .onAppear {
                AnalyticsReporter.reportScreen("AzkarSearch", className: viewName)
            }
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.isPerformingSearch {
            ProgressView()
                .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.haveSearchResults == false {
            Text(L10n.Common.noSearchResults)
                .systemFont(.title3)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(Color.secondaryText)
                .padding()
        } else {
            searchResultsList
        }
    }
    
    var searchResultsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.searchResults) { section in
                    searchResultSectionView(section)
                }
            }
            .padding(.vertical)
        }
        .automaticKeyboardDismissing()
    }
    
    func searchResultSectionView(_ section: SearchResultsSection) -> some View {
        Section {
            ForEach(section.results, content: searchResultView)
                .padding()
                .foregroundStyle(Color.text)
                .background(Color.contentBackground)
                .applyTheme()
                .padding(.horizontal)
        } header: {
            HStack {
                if let image = section.image {
                    Image(systemName: image)
                }
                if let title = section.title {
                    Text(title)
                        .systemFont(.title3, modification: .smallCaps)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .foregroundStyle(Color.secondaryText)
            .background(Color.background)
            .padding(.top, 6)
        }
    }
 
    func searchResultView(for result: SearchResultZikr) -> some View {
        Button {
            onSelect(result)
        } label: {
            SearchResultsItemView(result: result)
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
