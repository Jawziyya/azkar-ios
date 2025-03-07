// ASCollectionView. Created by Apptek Studios 2019

import SwiftUI

struct MainMenuSmallGroup: View {
    
	var item: AzkarMenuType
    var flip = false

	var body: some View {
		HStack {
            image
            title
        }
        .environment(\.layoutDirection, flip ? .rightToLeft : .leftToRight)
	}
    
    @ViewBuilder
    var image: some View {
        switch item.iconType {
        case .system, .bundled:
            item.image.flatMap { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(item.imageCornerRadius)
                    .padding(.vertical, 8)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(item.color)
            }
        case .emoji:
            Text(item.imageName)
                .minimumScaleFactor(0.1)
                .font(Font.largeTitle)
                .padding(.vertical, 4)
                .frame(width: 40, height: 40)
        }
    }

    var title: some View {
        Text(item.title)
            .systemFont(.body)
            .frame(maxWidth: .infinity, alignment: flip ? .trailing : .leading)
            .foregroundStyle(.text)
            .multilineTextAlignment(flip ? .trailing : .leading)
            .environment(\.layoutDirection, flip ? .rightToLeft : .leftToRight)
    }

}

#Preview("Main Menu Small Group items demo.") {
    List {
        MainMenuSmallGroup(item: AzkarMenuItem.demo)
        MainMenuSmallGroup(item: AzkarMenuItem.noCountDemo)
        MainMenuSmallGroup(item: AzkarMenuItem.noCountDemo, flip: true)
        MainMenuSmallGroup(item: AzkarMenuOtherItem(groupType: .notificationsAccess, imageName: "🌍", title: "Title", color: Color.red, iconType: .emoji), flip: false)
        MainMenuSmallGroup(item: AzkarMenuOtherItem(groupType: .notificationsAccess, imageName: "🌗", title: "Священный месяц рамадан 1442 г.х. (2021 г.)", color: Color.red, iconType: .emoji), flip: true)
    }
    .listStyle(.plain)
}
