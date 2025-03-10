// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import WidgetKit
import SwiftUI

@main
struct AzkarWidgetsBundle: WidgetBundle {
    var body: some Widget {
        VirtuesWidgets()
        if #available(iOSApplicationExtension 16.1, *) {
            CompletionWidgets()
        }
    }
}
