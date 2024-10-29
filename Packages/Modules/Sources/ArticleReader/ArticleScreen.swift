import SwiftUI
import NukeUI
import Entities
import Perception

public struct ArticleScreen: View {
    
    let viewModel: ArticleViewModel
    var shareOptions: ShareOptions?
    let onShareButtonTap: () -> Void
    
    public struct ShareOptions {
        let maxWidth: CGFloat
        
        public init(maxWidth: CGFloat) {
            self.maxWidth = maxWidth
        }
    }
    
    public init(
        viewModel: ArticleViewModel,
        shareOptions: ShareOptions? = nil,
        onShareButtonTap: @escaping () -> Void = {}
    ) {
        self.viewModel = viewModel
        self.shareOptions = shareOptions
        self.onShareButtonTap = onShareButtonTap
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
        WithPerceptionTracking {
            if let shareOptions {
                VStack(spacing: 20) {
                    content
                    sharedWithAzkarView
                }
                .frame(width: shareOptions.maxWidth)
                .frame(maxHeight: .infinity)
            } else {
                content
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem {
                            shareButton
                        }
                    }
            }
        }
    }
    
    @MainActor @ViewBuilder
    public var content: some View {
        ScrollView {
            VStack(spacing: 16) {
                if shareOptions == nil {
                    headerView
                    scrollableContent
                } else {
                    Text(viewModel.title)
                        .font(Font.system(size: 30, weight: .black, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .dynamicTypeSize(.accessibility5)
                        .padding(.horizontal)
                    
                    scrollableContent
                }
            }
        }
    }
    
    var sharedWithAzkarView: some View {
        VStack {
            Image(uiImage: UIImage(named: "ink")!)
                .resizable()
                .frame(width: 30, height: 30)
                .cornerRadius(6)
            Text("share.shared-with-azkar")
                .foregroundColor(Color.secondary)
                .font(Font.system(size: 12, weight: .regular, design: .rounded).smallCaps())
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 45)
        .opacity(0.5)
    }
    
    var shareButton: some View {
        Button(action: onShareButtonTap, label: {
            Image(systemName: "square.and.arrow.up")
        })
    }
    
    var headerView: some View {
        ArticleHeaderView(
            title: viewModel.title,
            tags: viewModel.tags,
            cover: viewModel.coverImage,
            coverAltText: viewModel.coverImageAltText,
            views: viewModel.views,
            viewsAbbreviated: viewModel.viewsAbbreviated,
            shares: viewModel.shares,
            sharesAbbreviated: viewModel.sharesAbbreviated,
            imageMaxHeight: maxHeight
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
    return ArticleViewModel(
        article: .placeholder(
            coverImage: .init(
                imageType: .link(imageLink),
                imageFormat: coverImageFormat
            )
        ),
        analyticsStream: { AsyncStream { _ in } },
        updateAnalytics: { _ in },
        fetchArticle: { return nil }
    )
}

let demoImageURL = URL(string: "https://azkar.ams3.digitaloceanspaces.com/media/post-covers/2_zikru_llahi")!

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
    ArticleScreenPreview(
        viewModel: .init(
            article: .placeholder(),
            analyticsStream: { AsyncStream { _ in } },
            updateAnalytics: { _ in },
            fetchArticle: { return nil }
        )
    )
}
