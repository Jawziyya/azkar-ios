import SwiftUI
import NukeUI
import Popovers
import Extensions
import Entities

extension Article.ImageType {
    @ViewBuilder @MainActor
    func getImageView(_ maxHeight: CGFloat = .infinity) -> some View {
        switch self {
            
        case .link(let link):
            LazyImage(url: link) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .accentColor(Color.primary)
                } else if state.isLoading {
                    Color(.systemBackground)
                        .overlay {
                            ProgressView()
                        }
                } else {
                    PatternView()
                }
            }
            .frame(minWidth: 0, maxHeight: maxHeight)
            
        case .resource(let name):
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .accentColor(Color.primary)
                .frame(minWidth: 0, maxHeight: maxHeight)
            
        }
    }
}

private struct StatsView: View {
    
    let abbreviatedNumber: String
    let number: String
    let imageName: String
    @State var showNumber = false
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
            Text(abbreviatedNumber)
        }
        .onTapGesture {
            guard number != abbreviatedNumber else { return }
            withAnimation(.spring) {
                showNumber.toggle()
            }
        }
        .popover(
            present: $showNumber,
            view: {
                Text(number)
                    .frame(minWidth: 20)
                    .padding(4)
                    .foregroundStyle(Color.secondary)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .opacity(showNumber ? 1 : 0)
            }
        )
    }
}

struct ArticleHeaderView: View {
        
    let title: String
    var tags: [String]?
    var cover: Article.CoverImage?
    var coverAltText: String?
    var views: String?
    var viewsAbbreviated: String?
    var shares: String?
    var sharesAbbreviated: String?
    
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
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(Font.system(size: fontSize, weight: .black, design: .serif))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .dynamicTypeSize(.accessibility5)
                .lineLimit(lineLimit)
                .minimumScaleFactor(0.25)
            
            if #available(iOS 16, *) {
                ScrollView(.horizontal) {
                    horizontalScrollViewContent(foregroundColor: tagsForegroundColor)
                }
                .scrollIndicators(.never)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    horizontalScrollViewContent(foregroundColor: tagsForegroundColor)
                }
            }
        }
        .padding()
    }
    
    func horizontalScrollViewContent(
        foregroundColor: Color
    ) -> some View {
        HStack {
            countView(
                views,
                abbreviatedNumber: viewsAbbreviated,
                image: "eye"
            )
            countView(
                shares,
                abbreviatedNumber: sharesAbbreviated,
                image: "square.and.arrow.up"
            )
            Divider()
                .frame(height: 10)
            tagsView
        }
        .foregroundStyle(foregroundColor)
    }
    
    @MainActor @ViewBuilder
    var standaloneImage: some View {
        image
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .allowsHitTesting(false)
            .overlay(alignment: .topTrailing) {
                altTextView
            }
            .applyAccessibilityLabel(coverAltText)
            .padding()
    }
    
    @MainActor @ViewBuilder
    var image: some View {
        cover?.imageType.getImageView(imageMaxHeight)
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
            HStack {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(Font.callout)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
    
    @ViewBuilder
    private func countView(
        _ number: String?,
        abbreviatedNumber: String?,
        image: String
    ) -> some View {
        if let number, let abbreviatedNumber {
            StatsView(abbreviatedNumber: abbreviatedNumber, number: number, imageName: image)
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
        title: "Test title",
        tags: ["#benefit", "#general", "#info"],
        cover: .init(
            imageType: .link(demoImageURL),
            imageFormat: .titleBackground
        ),
        coverAltText: "MidJourney Image",
        views: "1231",
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
        views: "1231",
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
        views: "1231",
        imageMaxHeight: 300,
        scrollProgress: 1
    )
}
