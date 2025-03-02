// Copyright © 2022 Al Jawziyya. All rights reserved.

import Foundation
import SwiftUI

struct ZikrShareBackgroundItem: Identifiable, Hashable {
    let id = UUID()
    let backgroundType: BackgroundType
    var isProItem = true
    
    static let defaultBackground = ZikrShareBackgroundItem(backgroundType: .solidColor(Color.background), isProItem: false)
    
    private static let patternImageNames: [String] = [
        "tic-tac",
        "sun",
        "leaves",
    ]
    
    static var patternImages: [ZikrShareBackgroundItem] {
        patternImageNames.map { ZikrShareBackgroundItem(backgroundType: .patternImage(UIImage(named: "Patterns/" + $0)!)) }
    }
    
    private static let imageLinks: [String] = [
        "https://images.unsplash.com/photo-1740004731264-3cde5c198cc2?q=80&w=3504&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1617140237060-d09a58ba8edd?q=80&w=4480&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1738251396922-b6ef53f67b72?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw4Mnx8fGVufDB8fHx8fA%3D%3D",
        "https://images.unsplash.com/photo-1740387223785-6ab827ab4fb1?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMDF8fHxlbnwwfHx8fHw%3D",
        "https://images.unsplash.com/photo-1724174286667-a0e90006f534?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwxMzR8fHxlbnwwfHx8fHw%3D",
        "https://images.unsplash.com/photo-1522441815192-d9f04eb0615c?q=80&w=4433&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ]
    
    static var imageBackgrounds: [ZikrShareBackgroundItem] {
        imageLinks.map { ZikrShareBackgroundItem(backgroundType: .remoteImage(URL(string: $0)!)) }
    }
    
    enum BackgroundType: Hashable {
        case solidColor(Color)
        case patternImage(UIImage)
        case remoteImage(URL)
    }
    
    static var all: [ZikrShareBackgroundItem] {
        [defaultBackground] + patternImages + imageBackgrounds
    }
}
