import Foundation

public enum NotificationQuoteCategory: String, Hashable {
    case adhkar
    case jumua
}

public struct NotificationQuote: Identifiable, Hashable {

    public let id: Int
    public let text: String
    public let source: String?

    public init(
        id: Int,
        text: String,
        source: String?
    ) {
        self.id = id
        self.text = text
        self.source = source
    }

}
