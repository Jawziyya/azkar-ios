//
//  UIDevice.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 07.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit

extension UIDevice {

    var isInLandscapeMode: Bool {
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            return true
        default:
            return false
        }
    }

    var isIpad: Bool {
        userInterfaceIdiom == .pad
    }

    var isMac: Bool {
        #if targetEnvironment(macCatalyst)
        return true
        #else
        return false
        #endif
    }

}
