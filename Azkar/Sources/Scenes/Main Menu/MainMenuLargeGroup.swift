// ASCollectionView. Created by Apptek Studios 2019

import SwiftUI
import Components

struct MainMenuLargeGroup: View {

    let category: ZikrCategory
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.appTheme) var appTheme

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

            Text(category.title)
                .systemFont(.body)
                .multilineTextAlignment(.center)
				.foregroundStyle(Color.text)
                .layoutPriority(1)
		}
        .padding(15)
	}
    
    var imageView: some View {
        Image(imageName)
            .foregroundStyle(Color.text)
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
