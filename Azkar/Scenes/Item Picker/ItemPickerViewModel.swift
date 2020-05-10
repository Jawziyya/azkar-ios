//
//  ItemPickerViewModel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 04.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

protocol PickableItem {
    var title: String { get }
    var image: Image? { get }
    var subtitle: String? { get }
    var subtitleFont: Font { get }
}

extension PickableItem {

    var image: Image? {
        nil
    }

    var subtitle: String? {
        nil
    }

    var subtitleFont: Font {
        Font.footnote
    }

}

final class ItemPickerViewModel {

    

}
