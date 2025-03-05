// Copyright © 2022 Al Jawziyya. All rights reserved. 

import UIKit

public enum LineSpacing: String, Codable, CaseIterable, Identifiable {
    case s, m, l, xl

    public var id: String {
        rawValue
    }
    
    public var title: String {
        rawValue.uppercased()
    }

    public var value: CGFloat {
        switch self {
        case .s: return 0
        case .m: return 5
        case .l: return 10
        case .xl: return 25
        }
    }
}
