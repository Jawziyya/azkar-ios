// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import WidgetKit
import SwiftUI
import Entities
import Library

struct VirtuesProvider: TimelineProvider {
    
    let fadail: [Fadl] = {
        let databaseService = DatabaseService.shared
        let fadail = try? databaseService.getFudul()
        return fadail ?? []
    }()
    
    func placeholder(in context: Context) -> VirtueEntry {
        VirtueEntry.placeholder
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (VirtueEntry) -> ()
    ) {
        let entry = VirtueEntry(date: Date(), fadl: fadail[1])
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
