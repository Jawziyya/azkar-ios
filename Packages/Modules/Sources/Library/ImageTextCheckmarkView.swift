import SwiftUI
import Entities
import AzkarResources

public struct ImageTextCheckmarkView: View {
    let title: String
    let imageName: String
    var imageBundle: Bundle?
    var showChecmark = false
    
    public init(
        title: String,
        imageName: String,
        imageBundle: Bundle? = nil,
        showChecmark: Bool = false
    ) {
        self.title = title
        self.imageName = imageName
        self.imageBundle = imageBundle
        self.showChecmark = showChecmark
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(imageName, bundle: imageBundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundStyle(.text)

            HStack {
                Text(title)
                    .systemFont(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.text)
                    .layoutPriority(1)
                
                if showChecmark {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.secondaryText)
                        .font(.caption)
                }
            }
        }
        .padding(15)
    }
}

#Preview("Morning") {
    ImageTextCheckmarkView(
        title: "Morning",
        imageName: "categories/morning",
        imageBundle: azkarResourcesBundle
    )
}

@available(iOS 16.0, *)
#Preview("Evening") {
    ScrollView {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(MoonPhase.allCases, id: \.self) { phase in
                ImageTextCheckmarkView(
                    title: phase.rawValue,
                    imageName: "moon-phase-blue/\(phase.imageName)",
                    imageBundle: azkarResourcesBundle
                )
            }
        }
        .padding()
    }
    .scrollIndicators(.hidden)
}
