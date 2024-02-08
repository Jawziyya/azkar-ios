import SwiftUI
import ScalingHeaderScrollView
import NukeUI
import Entities

public struct ArticleScreen: View {
    
    let viewModel: ArticleViewModel
    
    public init(viewModel: ArticleViewModel) {
        self.viewModel = viewModel
    }
    
    private let minHeight = 175.0
    private var maxHeight: CGFloat {
        if viewModel.coverImage?.imageFormat == .titleBackground {
            return 250
        } else {
            return 200
        }
    }
    
    public var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
    }
    
    @MainActor @ViewBuilder
    public var content: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerView
                scrollableContent
            }
        }
    }
    
    var headerView: some View {
        ArticleHeaderView(
            title: viewModel.title,
            tags: viewModel.tags ?? [],
            cover: viewModel.coverImage,
            imageMaxHeight: maxHeight,
            scrollProgress: 0
        )
    }
    
    var scrollableContent: some View {
        VStack(spacing: 0) {
            textContent
            
            Color.clear.frame(height: 100)
        }
        .padding(.horizontal)
    }
    
    var textContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            if #available(iOS 16.0, *) {
                Text(LocalizedStringKey(viewModel.text))
                    .font(Font.system(.body, design: .serif, weight: .regular))
            } else {
                Text(LocalizedStringKey(viewModel.text))
            }
        }
        .frame(maxWidth: .infinity)
    }
    
}

private func getDemoVM(
    _ coverImageFormat: ArticleDTO.CoverImageFormat,
    _ imageLink: URL
) -> ArticleViewModel {
    return ArticleViewModel(article: .placeholder(
        coverImage: .init(
            imageType: .link(imageLink),
            imageFormat: coverImageFormat
        )
    ))
}

let demoImageURL = URL(string: "https://images.unsplash.com/photo-1706965272053-a325d775d42b?q=80&w=2982&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!

private struct ArticleScreenPreview: View {
    let viewModel: ArticleViewModel
    var body: some View {
        NavigationView {
            ArticleScreen(viewModel: viewModel)
        }
    }
}

#Preview("Background Image") {
    ArticleScreenPreview(viewModel: getDemoVM(.titleBackground, demoImageURL))
}

#Preview("Standalone Cover") {
    ArticleScreenPreview(viewModel: getDemoVM(.standaloneTop, demoImageURL))
}

#Preview("Standalone Under Title Cover") {
    ArticleScreenPreview(viewModel: getDemoVM(.standaloneUnderTitle, demoImageURL))
}

#Preview("No Image") {
    ArticleScreenPreview(viewModel: .init(article: .placeholder()))
}
