import WidgetKit
import SwiftUI

@available(iOS 16, *)
private struct AppIconView: View {
    var body: some View {
        if #available(iOS 17, *) {
            image
                .containerBackground(for: .widget) {
                    Color.clear
                }
        } else {
            image
        }
    }
    
    var image: some View {
        Image(systemName: "moon.stars.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(15)
            .widgetAccentable()
            .background(AccessoryWidgetBackground())
            .clipShape(Circle())
    }
}

@available(iOS 16, *)
struct LauncherWidgets: Widget {
    
    let kind = "AzkarLauncherWidgets"
    
    var body: some WidgetConfiguration {
        appIcon
            .supportedFamilies([.accessoryCircular])
            .containerBackgroundRemovable()
    }
    
    var appIcon: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: LauncherWidgetsTimelineProvider(), 
            content: { entry in
                AppIconView()
            }
        )
        .supportedFamilies([.accessoryCircular])
        .configurationDisplayName(L10n.Widgets.Launcher.title)
    }
    
}

@available(iOS 17, *)
#Preview(as: .accessoryCircular) {
    LauncherWidgets()
} timeline: {
    LauncherWidgetsEntry()
}
