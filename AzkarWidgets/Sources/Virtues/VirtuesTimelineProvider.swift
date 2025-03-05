// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import WidgetKit
import SwiftUI
import Entities
import AzkarServices

let APP_GROUP_USER_DEFAULTS = UserDefaults(suiteName: "group.io.jawziyya.azkar-app") ?? .standard

struct VirtuesProvider: TimelineProvider {
    
    private var fadail: [Fadl]
    
    init(
        databaseService: AdhkarDatabaseService
    ) {
        fadail = (try? databaseService.getFadail(language: nil)) ?? []
        if fadail.isEmpty {
            fadail = (try? databaseService.getFadail(language: databaseService.language.fallbackLanguage)) ?? []
        }
    }
    
    func getVirtue(at index: Int) -> Fadl {
        guard index < fadail.count else {
            return Fadl.placeholder
        }
        return fadail[index]
    }
    
    func getRandomVirtue() -> Fadl {
        guard let random = fadail.randomElement() else {
            return Fadl.placeholder
        }
        return random
    }
    
    func placeholder(in context: Context) -> VirtueEntry {
        VirtueEntry(date: Date(), fadl: getRandomVirtue())
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (VirtueEntry) -> ()
    ) {
        let entry = VirtueEntry(date: Date(), fadl: getRandomVirtue())
        completion(entry)
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<VirtueEntry>) -> ()
    ) {
        var entries: [VirtueEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for (index, fadl) in fadail.shuffled().enumerated() {
            let entryDate = Calendar.current.date(
                byAdding: .minute,
                value: (index + 1) * 15,
                to: currentDate
            )!
            let entry = VirtueEntry(
                date: entryDate,
                fadl: fadl
            )
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}
