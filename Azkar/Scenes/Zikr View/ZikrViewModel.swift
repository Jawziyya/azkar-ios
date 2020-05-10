//
//  ZikrViewModel.swift
//  Azkar
//
//  Created by Al Jawziyya on 07.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation
import Combine

struct ZikrViewModel: Identifiable, Equatable {

    static func == (lhs: ZikrViewModel, rhs: ZikrViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    var id: String {
        title
    }

    let zikr: Zikr
    let title: String

    init(zikr: Zikr) {
        self.zikr = zikr
        title = zikr.title ?? "Зикр №\(zikr.rowInCategory)"
    }

}
