import SwiftUI
import SwiftUIX
import Entities
import Library

struct SearchSuggestionsView: View {
    
    @Environment(\.appTheme) var appTheme
    @ObservedObject var viewModel: SearchSuggestionsViewModel
    
    let onSearchSuggestionSelection: (String) -> Void
        
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                content
            }
        }
        .customScrollContentBackground()
        .background(.background, ignoreSafeArea: .all)
        .task {
            await viewModel.loadSuggestions()
        }
        .onAppear {
            AnalyticsReporter.reportScreen("Azkar Search", className: viewName)
        }
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.suggestedQueries.isEmpty == false {
            suggestedSearchQueriesSection
        }
        
        if viewModel.suggestedAzkar.isEmpty == false {
            suggestedAzkarSection
        }
    }
    
    var suggestedSearchQueriesSection: some View {
        Section {
            ForEachIndexed(viewModel.suggestedQueries) { idx, position, query in
                Button {
                    onSearchSuggestionSelection(query)
                } label: {
                    HStack {
                        Image(systemName: .magnifyingglass)
                            .foregroundStyle(Color.secondary)
                        Text(query)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding()
                .foregroundStyle(.text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.contentBackground)
                .applyTheme(indexPosition: position)
                .padding(.horizontal)
            }
        } header: {
            headerView("search.suggested-queries")
        }
    }
    
    var suggestedAzkarSection: some View {
        Section {
            ForEachIndexed(viewModel.suggestedAzkar) { idx, position, zikr in
                let text = zikr.title ?? zikr.translation ?? zikr.text
                NavigationButton(
                    title: text.prefix(50) + "...",
                    applyVerticalPadding: false,
                    action: {
                        viewModel.navigateToZikr(zikr)
                    }
                )
                .padding()
                .foregroundStyle(.text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.contentBackground)
                .applyTheme(indexPosition: position)
                .padding(.horizontal)
            }
        } header: {
            headerView("search.suggested-adhkar")
        }
    }
    
    func headerView(_ label: LocalizedStringKey) -> some View {
        Text(label)
            .foregroundStyle(.secondaryText)
            .systemFont(.title3, modification: .smallCaps)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(.background)
            .padding(.top, 6)
    }
    
    func clearAllMenu(action: @escaping () -> Void) -> some View {
        Menu {
            Text("Please confirm this action")
                .font(.caption)
                .foregroundStyle(.secondary)
            Button(role: .destructive, action: action) {
                Label("Clear", systemImage: "trash")
            }
        } label: {
            Text("Clear All")
        }
    }
    
}

#Preview("Search Suggestions") {
    List {
        SearchSuggestionsView(
            viewModel: .placeholder,
            onSearchSuggestionSelection: { _ in }
        )
    }
}
