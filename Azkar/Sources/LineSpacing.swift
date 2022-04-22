// Copyright © 2022 Al Jawziyya. All rights reserved. 

import UIKit

enum LineSpacing: String, Codable, CaseIterable {
    case s, m, l, xl

    var title: String {
        rawValue.uppercased()
    }

    var value: CGFloat {
        switch self {
        case .s: return 0
        case .m: return 10
        case .l: return 20
        case .xl: return 35
        }
    }
}

extension LineSpacing: Identifiable {
    var id: String {
        rawValue
    }
}
