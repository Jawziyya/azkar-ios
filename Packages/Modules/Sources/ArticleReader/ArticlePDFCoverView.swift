import SwiftUI
import Entities
import Nuke

public struct ArticlePDFCoverView: View {
    
    let article: Article
    let maxHeight: CGFloat
    let logoImage: UIImage?
    let logoSubtitle: String
    @Environment(\.appTheme) var appTheme
    
    public init(
        article: Article,
        maxHeight: CGFloat,
        logoImage: UIImage?,
        logoSubtitle: String
    ) {
        self.article = article
        self.maxHeight = maxHeight
        self.logoImage = logoImage
        self.logoSubtitle = logoSubtitle
    }
    
    public var body: some View {
        VStack(spacing: 20)  {
            titleView
            
            Spacer()
            
            VStack {
                if let logoImage {                
                    Image(uiImage: logoImage)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .cornerRadius(6)
                }
                Text(logoSubtitle)
                    .systemFont(12, modification: .smallCaps)
            }
            .opacity(0.5)
            
            if let coverImageAltText = article.coverImageAltText {
                Text(coverImageAltText)
                    .font(Font.caption2)
                    .foregroundStyle(Color.white)
                    .opacity(0.25)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .foregroundStyle(Color.white)
        .padding(.horizontal, 40)
        .padding(.vertical, 50)
        .background(Color.black.opacity(0.75))
        .background(image.ignoresSafeArea())
    }
    
    @MainActor @ViewBuilder
    var image: some View {
        switch article.coverImage?.imageType {
        case .link(let url):
            let pipeline = ImagePipeline.shared.cache
            let cachedImage = pipeline.cachedImage(for: .init(url: url))
            if let image = cachedImage?.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                EmptyView()
            }
            
        case .resource(let name):
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
        default:
            EmptyView()
        }
    }
    
    var titleView: some View {
        Text(article.title)
            .font(Font.system(size: 50, weight: .black, design: .serif))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .multilineTextAlignment(.leading)
            .dynamicTypeSize(.accessibility5)
            .minimumScaleFactor(0.25)
    }
    
}

#Preview {
    ArticlePDFCoverView(
        article: .placeholder(
            coverImage: .init(
                imageType: .link(URL(string: "https://images.unsplash.com/photo-1710959575225-835d7d4a3b8f?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!),
                imageFormat: .standaloneTop
            ),
            coverImageAltText: "Unsplash: Abdullah Hijazi"
        ),
        maxHeight: 500,
        logoImage: UIImage(systemName: "moon")!,
        logoSubtitle: "Приложение Azkar"
    )
}
