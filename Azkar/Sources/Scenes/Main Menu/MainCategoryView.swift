import SwiftUI
import Library
import Entities
import AzkarResources

struct MainCategoryView: View {
    
    let category: ZikrCategory
    var showCheckmark = false
    
    init(
        category: ZikrCategory,
        showChecmark: Bool = false
    ) {
        self.category = category
        self.showCheckmark = showChecmark
    }

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            imageView
                .frame(width: 50, height: 50)

            HStack {
                Text(category.title)
                    .systemFont(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.text)
                    .layoutPriority(1)
                
                if showCheckmark {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.secondaryText)
                        .font(.caption)
                }
            }
        }
        .padding(15)
    }
    
    @ViewBuilder private var imageView: some View {
        switch category {
        case .morning:
            Image("categories/morning", bundle: azkarResourcesBundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundStyle(.text)
        case .evening:
            LunarPhaseView(info: LunarPhaseInfo(Date()))
        default:
            EmptyView()
        }
    }
    
}
