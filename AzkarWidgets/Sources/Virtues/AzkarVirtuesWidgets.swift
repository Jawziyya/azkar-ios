// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import WidgetKit
import SwiftUI
import Entities
import Library

struct AzkarVirtuesWidgets: Widget {
    let kind: String = "AzkarVirtuesWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: VirtuesProvider()
        ) { entry in
            WidgetsEntryView(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName(NSLocalizedString("widgets.virtues.title", comment: "Virtues of adhkar widget name"))
        .description(NSLocalizedString("widgets.virtues.description", comment: "Virtues of adhkar widget description"))
    }
    
}

struct AzkarVirtuesWidgets_Previews: PreviewProvider {
    static var previews: some View {
        let databaseService = DatabaseService.shared
        let fadail = try? databaseService.getFudul()
        
        return WidgetsEntryView(
            entry: VirtueEntry(
                date: Date(),
                fadl: fadail!.first!
            ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
