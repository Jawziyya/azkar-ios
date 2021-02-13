// ASCollectionView. Created by Apptek Studios 2019

import SwiftUI

struct MainMenuSmallGroup: View {

	var item: AzkarMenuType
    var flip = false

	var body: some View {
		HStack {
            item.image.flatMap { image in
                image
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .frame(width: 40, height: 40)
                    .foregroundColor(item.color)
            }

            HStack {
                Text(item.title)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(.label))
                    .environment(\.layoutDirection, .leftToRight)

                Spacer()

                item.count.flatMap { count in
                    Text("\(count)")
                        .font(Font.subheadline)
                        .foregroundColor(Color.secondaryText)
                }
            }
        }
        .environment(\.layoutDirection, flip ? .rightToLeft : .leftToRight)
	}

}

struct GroupSmall_Previews: PreviewProvider {
	static var previews: some View {
        Group {
            MainMenuSmallGroup(item: AzkarMenuItem.demo)
            MainMenuSmallGroup(item: AzkarMenuItem.noCountDemo)
            MainMenuSmallGroup(item: AzkarMenuItem.noCountDemo, flip: true)
        }
        .previewLayout(.fixed(width: 300, height: 400))
	}
}
