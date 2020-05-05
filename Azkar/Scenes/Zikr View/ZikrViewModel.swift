//
//  ZikrViewModel.swift
//  Azkar
//
//  Created by Al Jawziyya on 07.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation
import Combine

struct ZikrViewModel {

    let zikr: Zikr
    let title: String
    let playerViewModel: PlayerViewModel

    init(zikr: Zikr, player: Player) {
        self.zikr = zikr
        title = zikr.title ?? "Зикр №\(zikr.rowInCategory)"
        playerViewModel = .init(audioURL: zikr.audioURL, player: player)
    }

}
