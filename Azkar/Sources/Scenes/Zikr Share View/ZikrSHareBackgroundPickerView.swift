// Copyright © 2022 Al Jawziyya. All rights reserved.

import SwiftUI
import NukeUI
import Nuke
import Library

struct ZikrShareBackgroundPickerView: View {
    let backgrounds: [ZikrShareBackgroundItem]
    @Binding var selectedBackground: ZikrShareBackgroundItem
    @Environment(\.appTheme) var appTheme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(backgrounds) { item in
                    ZikrShareBackgroundCardView(
                        item: item, 
                        isSelected: selectedBackground == item
                    )
                    .onTapGesture {
                        selectedBackground = item
                    }
                    .padding(5)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 80)
    }
}

struct ZikrShareBackgroundCardView: View {
    let item: ZikrShareBackgroundItem
    let isSelected: Bool
    @Environment(\.appTheme) var appTheme
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        backgroundContent
            .frame(width: 55, height: 75)
            .clipShape(RoundedRectangle(cornerRadius: appTheme.cornerRadius/2))
            .overlay(
                RoundedRectangle(cornerRadius: appTheme.cornerRadius/2)
                    .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .overlay(
                displayProBadge ? 
                ProBadgeView()
                    .padding(6)
                    .allowsHitTesting(false)
                    .shadow(color: Color.yellow.opacity(0.8), radius: 2, x: 0, y: 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                : nil
            )
            .shadow(color: isSelected ? Color.accentColor.opacity(0.5) : Color.clear, 
                    radius: 3, x: 0, y: 0)
    }
    
    private var displayProBadge: Bool {
        SubscriptionManager.shared.isProUser() == false && item.isProItem
    }
    
    @ViewBuilder
    private var backgroundContent: some View {
        switch item.backgroundType {
        case .solidColor(let color):
            color
        case .localImage(let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        case .remoteImage(let item):
            LazyImage(url: item.previewURL) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    ZStack {
                        Color.gray.opacity(0.2)
                        if state.isLoading {
                            ProgressView()
                        }
                    }
                }
            }
            .pipeline(.shared)
        }
    }
}

struct HorizontalBackgroundPicker_Previews: PreviewProvider {
    static var previews: some View {
        ZikrShareBackgroundPickerView(
            backgrounds: ZikrShareBackgroundItem.preset,
            selectedBackground: .constant(ZikrShareBackgroundItem.defaultBackground)
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
