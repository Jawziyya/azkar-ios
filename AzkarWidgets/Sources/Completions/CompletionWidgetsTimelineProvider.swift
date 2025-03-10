import WidgetKit
import AzkarServices

struct CompletionWidgetsTimelineProvider: TimelineProvider {
    typealias Entry = CompletionWidgetsEntry

    let zikrCounterService: ZikrCounterType
    
    init(
        zikrCounterService: ZikrCounterType
    ) {
        self.zikrCounterService = zikrCounterService
    }

    func placeholder(in context: Context) -> Entry {
        Entry(completionState: .morning)
    }

    private func getCompletionState() async -> CompletionState {
        let isMorningCompleted = await zikrCounterService.isCategoryMarkedAsCompleted(.morning)
        let isEveningCompleted = await zikrCounterService.isCategoryMarkedAsCompleted(.evening)
        let isNightCompleted = await zikrCounterService.isCategoryMarkedAsCompleted(.night)
        
        var completionState: CompletionState = []
        if (isMorningCompleted) { completionState.insert(.morning) }
        if (isEveningCompleted) { completionState.insert(.evening) }
        if (isNightCompleted) { completionState.insert(.night) }
        
        return completionState
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        Task {
            let completionState = await getCompletionState()
            let entry = Entry(completionState: completionState)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            let completionState = await getCompletionState()
            let entry = Entry(completionState: completionState)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}
