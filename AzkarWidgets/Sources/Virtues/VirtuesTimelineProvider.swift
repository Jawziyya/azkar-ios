// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import WidgetKit
import SwiftUI
import Entities
import Library

struct VirtuesProvider: TimelineProvider {
    
    let fadail: [Fadl] = {
        let databaseService = DatabaseService(language: Language.getSystemLanguage())
        let fadail = try? databaseService.getFadail()
        return fadail ?? []
    }()
    
    func getVirtue(at index: Int) -> Fadl {
        guard fadail.count < index else {
            return Fadl.placeholder
        }
        return fadail[index]
    }
    
    func getRandomVirtue() -> Fadl {
        getVirtue(at: Int.random(in: 0..<fadail.count))
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
        for (index, fadl) in fadail.enumerated() {
            let entryDate = Calendar.current.date(byAdding: .hour, value: index, to: currentDate)!
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
