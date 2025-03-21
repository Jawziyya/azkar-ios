// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import WidgetKit
import SwiftUI
import Entities
import AzkarServices
import DatabaseInteractors

struct VirtuesWidgets: Widget {
    let kind: String = "AzkarVirtuesWidgets"
    
    @Preference(
        "kContentLanguage",
        defaultValue: Language.getSystemLanguage(),
        userDefaults: APP_GROUP_USER_DEFAULTS
    )
    var language: Language
    
    var body: some WidgetConfiguration {
        if #available(iOS 16, *) {
            config
                .supportedFamilies([.systemMedium, .accessoryRectangular])
        } else {
            config
                .supportedFamilies([.systemMedium])
        }
    }

    var config: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: VirtuesProvider(
                databaseService: AdhkarSQLiteDatabaseService(language: language)
            )
        ) { entry in
            VirtueView(fadl: entry.fadl)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .configurationDisplayName(L10n.Widgets.Virtues.title)
        .description(L10n.Widgets.Virtues.description)
    }
    
}

struct AzkarVirtuesWidgets_Previews: PreviewProvider {
    static var previews: some View {
        let databaseService = AdhkarSQLiteDatabaseService(language: Language.getSystemLanguage())
        let fadail = try! databaseService.getFadail()
        
        return VirtueView(
            fadl: fadail.randomElement()!
        )
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
