import SwiftUI

public struct ShareBackground: Codable, Hashable {
    public let id: Int
    public let type: ShareBackgroundType
    public let url: URL
    public let previewUrl: URL?

    public init(id: Int, type: ShareBackgroundType, url: URL, previewUrl: URL?) {
        self.id = id
        self.type = type
        self.url = url
        self.previewUrl = previewUrl
    }
}
