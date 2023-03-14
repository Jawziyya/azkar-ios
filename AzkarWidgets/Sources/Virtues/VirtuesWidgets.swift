// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import WidgetKit
import SwiftUI
import Entities
import Library

struct VirtuesWidgets: Widget {
    let kind: String = "AzkarVirtuesWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: VirtuesProvider()
        ) { entry in
            VirtueView(fadl: entry.fadl)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName(NSLocalizedString("widgets.virtues.title", comment: "Virtues of adhkar widget name"))
        .description(NSLocalizedString("widgets.virtues.description", comment: "Virtues of adhkar widget description"))
    }
    
}

struct AzkarVirtuesWidgets_Previews: PreviewProvider {
    static var previews: some View {
        let databaseService = DatabaseService.shared
        let fadail = try! databaseService.getFudul()
        
        return VirtueView(
            fadl: fadail.randomElement()!
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
