import SwiftUI

public enum IndexPosition {
    case first, last, other
}

/// A view that renders a collection of identified data.
public struct ForEachIndexed<Data, Item, Content: View>: View where Data: RandomAccessCollection<Item>, Data.Index: Hashable, Item: Identifiable & Hashable {
    
    private let sequence: Data
    private let content: (Data.Index, IndexPosition, Item) -> Content

    public init(_ sequence: Data, @ViewBuilder _ content: @escaping (Data.Index, IndexPosition, Item) -> Content) {
        self.sequence = sequence
        self.content = content
    }

    public var body: some View {
        let indices = sequence.indices
        ForEach(Array(zip(indices, sequence)), id: \.1) { index, item in
            self.content(
                index,
                index == indices.first ? .first : index == indices.last ? .last : .other,
                item
            )
        }
    }
}
