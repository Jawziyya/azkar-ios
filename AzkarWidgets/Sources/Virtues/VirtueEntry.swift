// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import WidgetKit
import Entities

struct VirtueEntry: TimelineEntry {
    let date: Date
    let fadl: Fadl
    
    static var placeholder: VirtueEntry {
        VirtueEntry(
            date: Date(),
            fadl: Fadl.placeholder
        )
    }
}

