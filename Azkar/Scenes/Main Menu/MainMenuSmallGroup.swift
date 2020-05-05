// ASCollectionView. Created by Apptek Studios 2019

import SwiftUI

struct MainMenuSmallGroup: View {

	var item: AzkarMenuType

	var body: some View {
		HStack(alignment: .center) {
            item.image.flatMap { image in
                image
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .frame(width: 40, height: 40)
                    .foregroundColor(item.color)
            }

			Text(item.title)
				.multilineTextAlignment(.leading)
				.foregroundColor(Color(.label))

			Spacer()

            item.count.flatMap {
                Text("\($0)")
                    .font(Font.subheadline)
                    .foregroundColor(Color.secondaryText)
            }
		}
		.padding(10)
	}

}

struct GroupSmall_Previews: PreviewProvider {
	static var previews: some View {
        MainMenuSmallGroup(item: AzkarMenuItem.demo)
	}
}
