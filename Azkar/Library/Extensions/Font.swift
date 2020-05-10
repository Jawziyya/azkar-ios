//
//  Font.swift
//  Azkar
//
//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: CGFloat

    func body(content: Content) -> some View {
       let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.custom(name, size: scaledSize))
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
extension View {
    func scaledFont(name: String, size: CGFloat) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }
}

func textSize(forTextStyle textStyle: UIFont.TextStyle) -> CGFloat {
   return UIFont.preferredFont(forTextStyle: textStyle).pointSize
}

extension Font {

//    static func arabic(_ style: UIFont.TextStyle = .body) -> Font {
//        let size = textSize(forTextStyle: style)
//        return Font.custom(name, size: size)
//    }
//
//    static func arabicBold(_ style: UIFont.TextStyle = .body) -> Font {
//        let size = textSize(forTextStyle: style)
//        return Font.custom(name + "-Bold", size: size)
//    }

    static func textFont(_ style: UIFont.TextStyle = .body) -> Font {
        let size = textSize(forTextStyle: style)
        return Font.custom("IowanOldStyle-Roman", size: size)
    }
    
}
