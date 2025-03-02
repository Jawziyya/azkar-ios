// Copyright © 2022 Al Jawziyya. All rights reserved.

import SwiftUI
import NukeUI
import Nuke
import Library

struct ZikrSHareBackgroundPickerView: View {
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
        case .patternImage(let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        case .remoteImage(let url):
            LazyImage(url: url) { state in
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
        ZikrSHareBackgroundPickerView(
            backgrounds: ZikrShareBackgroundItem.all,
            selectedBackground: .constant(ZikrShareBackgroundItem.defaultBackground)
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
