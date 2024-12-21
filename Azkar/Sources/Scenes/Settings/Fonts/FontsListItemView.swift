// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Nuke
import NukeUI
import Entities
import Library

struct FontsListItemView: View {
    
    let vm: AppFontViewModel
    let isArabicFontsType: Bool
    let isLoadingFont: Bool
    let isSelectedFont: Bool
    let selectionCallback: () -> Void
    var isRedacted = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Group {
                if isArabicFontsType {
                    Text(vm.name)
                        .font(.system(.body))
                } else {
                    Text(vm.name)
                        .font(Font.customFont(vm.font, style: .body, sizeCategory: nil))
                }
            }
            .multilineTextAlignment(.leading)
            
            if isLoadingFont {
                ActivityIndicator(style: .medium, color: Color.text)
            }
            
            Spacer()
            
            if let imageURL = vm.imageURL {
                FontsListItemView.fontImageView(imageURL, isRedacted: isRedacted)
                    .frame(width: 100, height: 40)
                    .foregroundStyle(Color.accent)
                    .onTapGesture(perform: selectionCallback)
            }
            
            CheckboxView(isCheked: .constant(isSelectedFont))
                .frame(width: 20, height: 20)
        }
        .contentShape(Rectangle())
        .frame(minHeight: 44)
    }
    
    @MainActor
    static func fontImageView(_ url: URL?, isRedacted: Bool) -> some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .accentColor(Color.text)
            } else if state.error != nil {
                Color.clear
            } else {
                if isRedacted {
                    ActivityIndicator(style: .medium, color: Color.secondary)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .processors([
            ImageProcessors.Anonymous(id: "rendering-mode") { image in
                image.withRenderingMode(.alwaysTemplate)
            }
        ])
    }
    
}

struct FontsListItemView_Previews: PreviewProvider {
    static var previews: some View {
        FontsListItemView(
            vm: AppFontViewModel(
                font: ArabicFont.noto,
                language: Language.english
            ),
            isArabicFontsType: false,
            isLoadingFont: false,
            isSelectedFont: false,
            selectionCallback: {},
            isRedacted: false
        )
        .previewLayout(.fixed(width: 350, height: 50))
        .padding()
    }
}
