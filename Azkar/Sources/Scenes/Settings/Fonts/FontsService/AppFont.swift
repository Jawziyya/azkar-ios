// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

let STANDARD_FONT_REFERENCE_NAME = "standard-font-reference-name"

protocol AppFontStyle {
    var key: String { get }
}

protocol AppFont {
    var id: String { get }
    var style: AppFontStyle { get }
    var name: String { get }
    var referenceName: String { get }
    var postscriptName: String { get }
    var sizeAdjustment: Float? { get }
    var lineAdjustment: Float? { get }
}
