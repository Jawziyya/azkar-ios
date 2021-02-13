// ASCollectionView. Created by Apptek Studios 2019

import SwiftUI

struct MainMenuLargeGroup: View {

	var item: AzkarMenuItem

	var body: some View {
        VStack(alignment: .leading, spacing: 16) {
			HStack(alignment: .center) {
                Image(systemName: item.imageName)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .aspectRatio(contentMode: .fill)
                    .padding(10)
					.foregroundColor(Color.white)
                    .background(
                        Circle().fill(item.color)
                    )
				Spacer()

                item.count.flatMap {
                    Text("\($0)")
                        .font(Font.title)
                        .bold()
                }
			}
			Text(item.title)
                .font(Font.body)
				.bold()
				.multilineTextAlignment(.leading)
				.foregroundColor(Color.secondaryText)
		}
		.padding()
	}
}

struct GroupLarge_Previews: PreviewProvider {
	static var previews: some View {
		ZStack {
			Color(.secondarySystemBackground)
            MainMenuLargeGroup(item: AzkarMenuItem(category: .evening, imageName: "sun.max", title: "Test", color: Color.accent, count: Int.random(in: 5...20)))
		}
	}
}
