import Foundation

public struct Fadl: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case _source = "source", sourceExtension = "source_ext"
        case textRu = "text_ru", textEn = "text_en"
    }
    
    public let id: Int
    private let textRu: String?
    private let textEn: String?
    private let _source: String
    private let sourceExtension: String?
    
    public var text: String? {
        switch languageIdentifier {
        case .ru: return textRu
        case .en: return textEn
        default: return nil
        }
    }
    
    public var source: String {
        var source = NSLocalizedString("text.source." + _source.lowercased(), comment: "")
        if let ext = sourceExtension {
            source += ", " + ext
        }
        return source
    }
    
    public static var placeholder: Fadl {
        Fadl(
            id: -1,
            textRu: "Text Ru",
            textEn: "Text En",
            _source: "Source",
            sourceExtension: "source_ext"
        )
    }
    
}
