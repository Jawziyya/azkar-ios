import SwiftUI
import SwiftUIX

struct SearchSuggestionsView: View {
    
    @ObservedObject var viewModel: SearchSuggestionsViewModel
    
    var body: some View {
        List {
            content
        }
        .listStyle(.insetGrouped)
        .task {
            await viewModel.loadSuggestions()
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
        Section("Recent Search") {
            ForEach(viewModel.suggestedQueries) { query in
                HStack {
                    Image(systemName: .magnifyingglass)
                        .foregroundStyle(Color.secondary)
                    Text(query)
                }
                .searchCompletion(query)
            }
            .onDelete { indexSet in
                Task {
                    await viewModel.removeRecentQueries(at: indexSet)
                }
            }
            .foregroundStyle(Color.primary)
        }
    }
    
    var suggestedAzkarSection: some View {
        Section("Recent Azkar") {
            ForEach(viewModel.suggestedAzkar) { zikr in
                Button(action: {
                    viewModel.navigateToZikr(zikr)
                }, label: {
                    let text = zikr.title ?? zikr.translation ?? zikr.text
                    Text(text.prefix(50) + "...")
                })
            }
            .onDelete { indexSet in
                Task {
                    await viewModel.removeRecentAzkar(at: indexSet)
                }
            }
            .foregroundStyle(Color.primary)
        }
    }
    
    func clearAllMenu(action: @escaping () -> Void) -> some View {
        Menu {
            Text("Please confirm this action")
                .font(.caption)
                .foregroundColor(.secondary)
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
            viewModel: .placeholder
        )
    }
}
