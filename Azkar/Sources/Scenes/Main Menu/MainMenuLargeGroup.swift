// ASCollectionView. Created by Apptek Studios 2019

import SwiftUI
import Components

struct MainMenuLargeGroup: View {

    let category: ZikrCategory
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.appTheme) var appTheme
    @EnvironmentObject var counter: ZikrCounter
    @State private var isCompleted = false

	var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Group {
                switch appTheme {
                case .reader, .flat:
                    imageView
                default:
                    animationView
                }
            }
            .frame(width: 60, height: 60)

            HStack {
                Text(category.title)
                    .systemFont(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.text)
                    .layoutPriority(1)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.secondaryText)
                        .font(.caption)
                }
            }
		}
        .padding(15)
        .task {
            isCompleted = await counter.isCategoryMarkedAsCompleted(category)
        }
	}
    
    var imageView: some View {
        Image(imageName)
            .foregroundStyle(.text)
    }
    
    var imageName: String {
        return appTheme.assetsNamespace + category.rawValue
    }
    
    var animationView: some View {
        LottieView(
            name: animationName,
            loopMode: .loop,
            contentMode: .scaleAspectFit,
            speed: 0.5
        )
        
    }
    
    var animationName: String {
        switch category {
        case .evening where colorScheme == .dark: return "moon"
        case .evening where colorScheme == .light: return "moon2"
        default: return "sun"
        }
    }
    
}

#Preview("Morning") {
    MainMenuLargeGroup(category: .morning)
}

#Preview("Evening") {
    MainMenuLargeGroup(category: .evening)
}
