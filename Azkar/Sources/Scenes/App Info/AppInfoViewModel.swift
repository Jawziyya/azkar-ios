//  Copyright © 2020 Al Jawziyya. All rights reserved.

import UIKit
import Combine
import SwiftUI

struct SourceInfo: Decodable {
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        sections = try container.decode([Section].self)
    }
    
    let sections: [Section]
    
    struct Item: Decodable, Identifiable {
        var id: String {
            return title
        }
        let title: String
        let link: String
        
        enum CodingKeys: String, CodingKey {
            case title, link
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let title = try container.decode(String.self, forKey: .title)
            self.title = NSLocalizedString(title, comment: "")
            link = try container.decode(String.self, forKey: .link)
        }
    }
    
    struct Section: Decodable {
        let title: String
        let items: [Item]
    }
}

final class AppInfoViewModel: ObservableObject {

    var sections: [Section] = []

    struct Section: Identifiable {
        let id = UUID().uuidString
        var header: String?
        var footer: String?
        let items: [SourceInfo.Item]
    }

    let preferences: Preferences
    let appVersion: String
    @Published private(set) var iconImageName: String

    private var cancellables = Set<AnyCancellable>()
    let subscriptionManager: SubscriptionManagerType

    init(
        preferences: Preferences,
        subscriptionManager: SubscriptionManagerType = SubscriptionManagerFactory.create()
    ) {
        self.preferences = preferences
        self.subscriptionManager = subscriptionManager
        iconImageName = preferences.appIcon.imageName
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!

        appVersion = "\(L10n.Common.version) \(version) (\(build))"
        
        let allIcons = AppIcon.allCases.shuffled()
        let allIconsCount = allIcons.count
        
        Timer.publish(every: 3, on: .main, in: .default)
            .autoconnect()
            .scan(0, { time, output in
                time + 1
            })
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                let index = min(allIconsCount - 1, max(0, (value % allIconsCount)))
                withAnimation(Animation.spring().speed(0.5)) {
                    self?.iconImageName = allIcons[index].imageName
                }
            }
            .store(in: &cancellables)
        
        let url = Bundle.main.url(forResource: "credits", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let sections = try! JSONDecoder().decode([SourceInfo.Section].self, from: data)
        
        self.sections = sections.map { section in
            Section(header: NSLocalizedString(section.title, comment: ""), footer: nil, items: section.items)
        }
    }

}
