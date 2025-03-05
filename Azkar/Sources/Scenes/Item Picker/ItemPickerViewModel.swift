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
}

extension String: PickableItem {
    var title: String {
        self
    }
}

extension PickableItem {

    var image: Image? {
        nil
    }

    var subtitle: String? {
        nil
    }

}

final class ItemPickerViewModel {

}
