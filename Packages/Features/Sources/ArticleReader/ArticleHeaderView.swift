import SwiftUI
import NukeUI

struct ArticleHeaderView: View {
        
    let title: String
    let tags: [String]?
    let cover: Article.CoverImage?
    let imageMaxHeight: CGFloat
    @State var scrollProgress: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            imageAndTitle
        }
    }
    
    @MainActor @ViewBuilder
    var imageAndTitle: some View {
        if let imageFormat = cover?.imageFormat {
            switch imageFormat {
                
            case .standaloneTop:
                VStack(spacing: 0) {
                    standaloneImage
                    getTitleView()
                }
                
            case .standaloneUnderTitle:
                VStack(spacing: 0) {
                    getTitleView()
                    standaloneImage
                }
                
            case .titleBackground:
                titleWithBackgroundImage
                
            }
        } else {
            getTitleView(45)
        }
    }
    
    @ViewBuilder
    func getTitleView(
        _ fontSize: CGFloat = 30,
        lineLimit: Int = 3,
        tagsForegroundColor: Color = Color.secondary
    ) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(Font.system(size: fontSize, weight: .black, design: .serif))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .dynamicTypeSize(.accessibility5)
                .lineLimit(lineLimit)
                .minimumScaleFactor(0.25)
            
            tagsView
                .foregroundStyle(tagsForegroundColor)
        }
        .padding()
    }
    
    @MainActor @ViewBuilder
    var standaloneImage: some View {
        image
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()
    }
    
    @MainActor @ViewBuilder
    var image: some View {
        switch cover?.imageType {
            
        case .link(let link):
            LazyImage(url: link) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .accentColor(Color.primary)
                } else {
                    PatternView()
                }
            }
            .frame(height: imageMaxHeight)
            
        case .resource(let name):
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .accentColor(Color.primary)
                .frame(height: imageMaxHeight)
            
        default:
            EmptyView()
            
        }
    }
    
    @MainActor
    var titleWithBackgroundImage: some View {
        image
            .clipped()
            .overlay(alignment: .bottom) {
                getTitleView(
                    40,
                    lineLimit: 2,
                    tagsForegroundColor: Color.white.opacity(0.55)
                )
                .foregroundStyle(Color.white)
                .opacity(1 - scrollProgress)
                .padding(.vertical)
                .background(
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.75)],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
            }
            .clipped()
    }
    
    @ViewBuilder
    var tagsView: some View {
        if let tags = tags {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .font(Font.callout)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
    
}

#Preview("Article Header") {   
    ArticleHeaderView(
        title: "Test",
        tags: ["#benefit", "#general", "#info"],
        cover: .init(
            imageType: .link(demoImageURL),
            imageFormat: .standaloneTop
        ),
        imageMaxHeight: 300,
        scrollProgress: 1
    )
}
