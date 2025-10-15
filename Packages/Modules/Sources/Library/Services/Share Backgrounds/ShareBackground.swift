import SwiftUI

public struct ShareBackground: Codable, Hashable {
    public let id: Int
    public let type: ShareBackgroundType
    public let url: URL
    public let previewUrl: URL?
}
