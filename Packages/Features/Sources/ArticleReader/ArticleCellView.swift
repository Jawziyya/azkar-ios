import SwiftUI
import Entities
import NukeUI
import Fakery
import RoughSwift

struct PatternView: View {
    var body: some View {
        RoughView()
            .fill([
                .systemGreen,
                .systemMint,
                .systemBlue,
                .systemCyan,
            ].randomElement()!)
            .fillStyle([
                .crossHatch,
                .dots,
                .dashed,
                .zigzagLine,
            ].randomElement()!)
            .rectangle()
            .opacity(0.25)
            .scaleEffect(x: 2, y: 2)
    }
}

public struct ArticleCellView: View {
    
    let title: String
    let category: String
    let imageType: Article.ImageType?
    
    public init(
        title: String,
        category: String,
        imageType: Article.ImageType?
    ) {
        self.title = title
        self.category = category
        self.imageType = imageType
    }
    
    public init(article: Article) {
        title = article.title
        category = article.category.title
        imageType = article.coverImage?.imageType
    }
    
    public var body: some View {
        image
            .frame(maxHeight: 200)
            .overlay(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(category)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .foregroundStyle(Color.white)
                        .background(Color.accentColor)
                        .clipShape(Capsule())
                        .padding()
                    
                    Spacer()
                    
                    Text(title)
                        .font(Font.system(size: 30, weight: .black, design: .serif))
                        .minimumScaleFactor(0.5)
                        .lineLimit(3)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [Color.clear, Color.black.opacity(0.75)],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                }
            }
            .clipped()
    }
    
    @MainActor @ViewBuilder
    var image: some View {
        switch imageType {
            
        case .link(let link):
            LazyImage(url: link) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .accentColor(Color.primary)
                } else {
                    Color.black
                }
            }
            
        case .resource(let name):
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .accentColor(Color.primary)
            
        default:
            PatternView()
            
        }
    }
    
}

#Preview("Remote Image") {
    let faker = Faker()
    
    return ArticleCellView(
        title: faker.lorem.words().capitalized,
        category: faker.lorem.word().capitalized,
        imageType: .link(demoImageURL)
    )
}

#Preview("No Image") {
    let faker = Faker()
    
    return ArticleCellView(
        title: faker.lorem.words().capitalized,
        category: faker.lorem.word().capitalized,
        imageType: nil
    )
}
