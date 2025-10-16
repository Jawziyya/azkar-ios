import SwiftUI
import Foundation

public struct ShareBackground: Codable, Hashable {
    public let id: Int
    public let type: ShareBackgroundType
    public let url: URL
    public let previewUrl: URL?
    public let createdAt: Date

    public init(id: Int, type: ShareBackgroundType, url: URL, previewUrl: URL?, createdAt: Date = Date()) {
        self.id = id
        self.type = type
        self.url = url
        self.previewUrl = previewUrl
        self.createdAt = createdAt
    }
}
