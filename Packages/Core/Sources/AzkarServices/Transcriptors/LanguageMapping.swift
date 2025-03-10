import Foundation
import Entities

public struct LanguageMapping {
    public struct CharacterData {
        public let characterType: TranscriptionCharacterType
        public let tashkeel: Tashkeel?
    }
    
    public typealias Mapping = (CharacterData) -> String?
    
    public let name: String
    public let mapping: Mapping
    
    public init(name: String, mapping: @escaping Mapping) {
        self.name = name
        self.mapping = mapping
    }
}

public extension ZikrTransliterationType {
    var mapping: LanguageMapping? {
        switch self {
        case .community: return nil
        case .DIN31635: return englishTranscriptionMapping
        case .ruScientific: return russianTranscriptionMapping
        }
    }
}
