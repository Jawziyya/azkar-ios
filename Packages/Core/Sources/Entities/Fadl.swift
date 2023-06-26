import Foundation

public struct Fadl: Identifiable {
        
    public let id: Int
    public let text: String
    public let source: String
    
    public static var placeholder: Fadl {
        Fadl(
            id: Int.random(in: -999 ... -1),
            text: faker.lorem.paragraphs(amount: Int.random(in: 1...2)),
            source: faker.lorem.words(amount: Int.random(in: 1...2))
        )
    }
    
}

extension Fadl {
    public init?(
        id: Int,
        text: String?,
        source: String
    ) {
        guard let text else {
            return nil
        }
        
        self.id = id
        self.text = text
        self.source = source
    }
}
