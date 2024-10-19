import SwiftUI

extension URL: @retroactive Identifiable {
    public var id: String {
        absoluteString
    }
}
