// Copyright © 2022 Al Jawziyya. All rights reserved. 

import UIKit

enum LineHeight: String, Codable, CaseIterable {
    case m, l, xl

    var title: String {
        rawValue.uppercased()
    }

    var spacing: CGFloat {
        switch self {
        case .m: return 0
        case .l: return 10
        case .xl: return 20
        }
    }
}

extension LineHeight: Identifiable {
    var id: String {
        rawValue
    }
}
