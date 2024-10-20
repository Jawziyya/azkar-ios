import WidgetKit

struct LauncherWidgetsTimelineProvider: TimelineProvider {
    typealias Entry = LauncherWidgetsEntry

    func placeholder(in context: Context) -> Entry {
        Entry()
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = Entry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = Entry()
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}
