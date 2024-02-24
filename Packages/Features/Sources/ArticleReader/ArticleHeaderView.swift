import SwiftUI
import NukeUI
import Popovers
import Extensions

struct ArticleHeaderView: View {
        
    let title: String
    var tags: [String]?
    var cover: Article.CoverImage?
    var coverAltText: String?
    let imageMaxHeight: CGFloat
    @State var scrollProgress: CGFloat
    @State var showAltText = false
    
    var body: some View {
        imageAndTitle
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
            .overlay(alignment: .topTrailing) {
                altTextView
            }
            .applyAccessibilityLabel(coverAltText)
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
            .frame(minWidth: 0)
            
        case .resource(let name):
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .accentColor(Color.primary)
                .frame(height: imageMaxHeight)
                .frame(minWidth: 0)
            
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
            .overlay(alignment: .topTrailing) {
                altTextView
            }
            .applyAccessibilityLabel(coverAltText)
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
    
    @ViewBuilder
    var altTextView: some View {
        if let coverAltText {
            Templates.Menu(
                configuration: { config in
                    config.popoverAnchor = .topRight
                }
            ) {
                Text(coverAltText)
                    .font(Font.caption)
                    .padding()
                    .cornerRadius(10)
            } label: { das in
                Text("ALT")
                    .padding(6)
                    .foregroundStyle(Color.white)
                    .background(Color.black)
                    .font(Font.caption.weight(.bold))
                    .cornerRadius(6)
                    .padding(8)
            }
        }
    }
    
}

#Preview("Background") {
    ArticleHeaderView(
        title: "Test",
        tags: ["#benefit", "#general", "#info"],
        cover: .init(
            imageType: .link(demoImageURL),
            imageFormat: .titleBackground
        ),
        coverAltText: "MidJourney Image",
        imageMaxHeight: 300,
        scrollProgress: 1
    )
}

#Preview("Standalone Top") {
    ArticleHeaderView(
        title: "Test",
        tags: ["#benefit", "#general", "#info"],
        cover: .init(
            imageType: .link(demoImageURL),
            imageFormat: .standaloneTop
        ),
        coverAltText: "MidJourney Image",
        imageMaxHeight: 300,
        scrollProgress: 1
    )
}

#Preview("Standalone Under title") {
    ArticleHeaderView(
        title: "Test",
        tags: ["#benefit", "#general", "#info"],
        cover: .init(
            imageType: .link(demoImageURL),
            imageFormat: .standaloneUnderTitle
        ),
        coverAltText: "man in black wear standing in the middle of an ice cold lake, in the style of stephan martinière, marina abramović, pictorial space, 32k uhd, alan bean, depictions of inclement weather, humanity's struggle",
        imageMaxHeight: 300,
        scrollProgress: 1
    )
}
