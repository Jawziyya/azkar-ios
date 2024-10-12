import Foundation
import SwiftUI

public enum AdSize: String, Codable, Hashable {
    case minimal
    case regular
}

public struct Ad: Identifiable, Decodable, Hashable {
    public let id: Int
    public let size: AdSize
    public var title: String?
    public var body: String?
    public var actionTitle: String?
    public let actionLink: URL
    public var imageLink: URL?
    public var backgroundColor: String?
    public var foregroundColor: String?
    public var accentColor: String?
}

public extension Ad {
    static var telegramBotDemo: Ad {
        Ad(
            id: Int.random(in: -100 ... 0),
            size: .regular,
            title: "Did you hear about our bot?",
            body: "We created a Telegram bot which helps you download free books",
            actionTitle: "Open Bot",
            actionLink: URL(string: "https://t.me/kutubist_bot")!,
            imageLink: URL(string: "https://images.unsplash.com/photo-1507738978512-35798112892c?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")
        )
    }
    
    static var hotelsDemo: Ad {
        Ad(
            id: Int.random(in: -100 ... 0),
            size: .minimal,
            title: "Are you traveling?",
            body: "Consider using our hotel room search service",
            actionTitle: "Find Hotel",
            actionLink: URL(string: "https://t.me/kutubist_bot")!
        )
    }
    
    static var ticketsDemo: Ad {
        Ad(
            id: Int.random(in: -100 ... 0),
            size: .minimal,
            title: "Are you traveling?",
            body: "Consider using our ticket search service",
            actionLink: URL(string: "https://t.me/kutubist_bot")!
        )
    }
}
