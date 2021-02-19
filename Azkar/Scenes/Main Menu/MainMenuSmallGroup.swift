// ASCollectionView. Created by Apptek Studios 2019

import SwiftUI

struct MainMenuSmallGroup: View {

	var item: AzkarMenuType
    var flip = false

	var body: some View {
		HStack {

            switch item.iconType {
            case .system, .bundled:
                item.image.flatMap { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                        .frame(width: 40, height: 40)
                        .foregroundColor(item.color)
                }
            case .emoji:
                Text(item.imageName)
                    .minimumScaleFactor(0.1)
                    .font(Font.largeTitle)
                    .frame(maxWidth: 35, maxHeight: 35)
            }

            HStack {
                if item.count == nil {
                    Spacer()
                }

                title

                if item.count != nil {
                    Spacer()
                }

                item.count.flatMap { count in
                    Text("\(count)")
                        .font(Font.subheadline)
                        .foregroundColor(Color.secondaryText)
                }
            }

        }
        .environment(\.layoutDirection, flip ? .rightToLeft : .leftToRight)
	}

    var title: some View {
        Text(item.title)
            .frame(maxWidth: .infinity, alignment: flip ? .trailing : .leading)
            .foregroundColor(Color.text)
            .multilineTextAlignment(flip ? .trailing : .leading)
            .environment(\.layoutDirection, flip ? .rightToLeft : .leftToRight)
    }

}

struct GroupSmall_Previews: PreviewProvider {
	static var previews: some View {
        Group {
            MainMenuSmallGroup(item: AzkarMenuItem.demo)
            MainMenuSmallGroup(item: AzkarMenuItem.noCountDemo)
            MainMenuSmallGroup(item: AzkarMenuItem.noCountDemo, flip: true)
            MainMenuSmallGroup(item: AzkarMenuOtherItem(groupType: .notificationsAccess, imageName: "🌍", title: "Title", color: Color.red, iconType: .emoji), flip: true)
            MainMenuSmallGroup(item: AzkarMenuOtherItem(groupType: .notificationsAccess, imageName: "🌗", title: "Священный месяц рамадан 1442 г.х. (2021 г.)", color: Color.red, iconType: .emoji), flip: true)
        }
        .previewLayout(.fixed(width: 300, height: 400))
	}
}
