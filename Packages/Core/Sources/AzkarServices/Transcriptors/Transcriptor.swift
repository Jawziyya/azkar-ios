import Foundation

public final class Transcriptor {
    
    private let languageMapping: LanguageMapping
    
    public init(mapping: LanguageMapping) {
        self.languageMapping = mapping
    }
    
    private func get(
        _ key: TranscriptionCharacterType,
        tashkeel: Tashkeel? = nil
    ) -> String {
        let keyData = LanguageMapping.CharacterData(
            characterType: key,
            tashkeel: tashkeel
        )
        if let mapped = languageMapping.mapping(keyData) {
            return mapped
        } else {
            print("Warning: No mapping found for \(key)")
            return ""
        }
    }
        
    // Transcribe function implementing the transcription rules
    public func transcribe(_ text: String) -> String {
        var out: [String] = []
        
        func append(_ key: TranscriptionCharacterType, tashkeel: Tashkeel? = nil) {
            out.append(get(key, tashkeel: tashkeel))
        }
        
        let normalizedText = normalizeTashkeel(text)
        let arabicText = ArabicText(text: String(normalizedText))
        
        var iterator = arabicText.makeIterator()
        while let character = iterator.next() {
            guard let symbolType = character.symbolType else {
                out.append(String(character.character))
                continue
            }
            
            let prevChar = character.prev()
            let prevSymbol = prevChar?.symbolType
            let nextChar = character.next()
            let nextSymbol = nextChar?.symbolType
            
            switch symbolType {
                
            case .tashkeel(.sukun), .harfExtension(.alifWaslaAbove):
                continue
                
            case .tashkeel(.shadda):
                if prevSymbol != symbolType, prevChar?.prev()?.symbolType != prevSymbol, let last = out.last, last.isEmpty == false {
                    out.append(last)
                }
                                            
            case .tashkeel(.damma):
                guard character.isEnd() == false else { continue }
                
                if character.isDammaFollowedByWaw() {
                    append(.vowel(.longU))
                    _ = iterator.next() // Skip Waw
                } else {
                    append(.vowel(.u))
                }
                
            case .tashkeel(.kasra):
                guard character.isEnd() == false else { continue }
                
                if character.isKasraPreceededByAlifWithHamzaBelow() {
                    continue
                } else if character.isKasraFollowedByYa() {
                    append(.vowel(.longI))
                    _ = iterator.next()
                } else {
                    append(.vowel(.i))
                }
                
            case .tashkeel(.fathatan):
                guard character.isEnd() == false else { continue }
                
                out.append(get(.vowel(.tanweenFatha)))
                if nextSymbol == .harf(.alif) {
                    _ = iterator.next()
                }
                
            case .tashkeel(.fatha):
                guard character.isEnd() == false else { continue }
                
                if character.isFathaFollowedByAlif() {
                    append(.vowel(.longA))
                    _ = iterator.next()
                } else {
                    append(.vowel(.a))
                }
                
            case .tashkeel(let tashkeel):
                let mapped: String
                // Fathatan is handled separately ↑
                switch tashkeel {
                case .dammatan: mapped = get(.vowel(.tanweenDamma))
                case .kasratan: mapped = get(.vowel(.tanweenKasra))
                default: continue
                }
                out.append(mapped)
                
            case .special(.space):
                if nextSymbol == .harf(.alif), nextChar?.next()?.symbolType == .harf(.lam) {
                    append(.special(.hyphen))
                } else {
                    append(.special(.space))
                }
                
            case .harf(.alif):
                // Check if 'Alif' is followed by 'Lam' and 'Lam' is followed by a sun letter
                if (prevChar == nil || prevChar?.isStart() == true), nextSymbol == .harf(.lam) {
                    append(.vowel(.a))
                    continue
                } else if prevChar != nil, nextSymbol == .harf(.lam) {
                    continue
                }
                
                if nextSymbol == .tashkeel(.damma) {
                    append(.vowel(.u))
                    _ = iterator.next()
                } else if nextSymbol == .tashkeel(.fatha) {
                    append(.vowel(.a))
                    _ = iterator.next()
                } else if nextSymbol == .tashkeel(.kasra) {
                    append(.vowel(.i))
                    _ = iterator.next()
                }
                
            case .harf(.lam):
                if prevSymbol == .harf(.alif), nextSymbol != .harf(.lam), nextChar?.harf?.isShamsiyyah() == true {
                    continue
                } else {
                    append(.harf(.lam), tashkeel: nextChar?.tashkeel)
                }
                                
            case .harf(.taMarbuta):
                if (nextSymbol == nil || nextChar?.isEndOfLine() == true) && nextChar?.tashkeel != nil {
                    append(.harf(.ha))
                    _ = iterator.next()
                } else {
                    append(.harf(.taMarbuta))
                }
                        
            case .harfExtension(.alifMaksura):
                if prevSymbol == .tashkeel(.fatha), let index = out.indices.last {
                    out[index] = get(.vowel(.longA)) // Replace with longer a.
                }
                continue
                
            case .harfExtension(.alifMaddaAbove):
                let mapping = get(.vowel(.longA))
                out.append(mapping)
                                
            case .harfExtension(let harfExt):
                
                switch harfExt {
                case .alifHamzaAbove:
                    if nextSymbol == .tashkeel(.damma) {
                        append(.vowel(.hamzaU))
                        _ = iterator.next()
                    } else {
                        append(.vowel(.hamzaA))
                        _ = iterator.next()
                    }
                case .alifHamzaBelow:
                    append(.vowel(.hamzaI))
                    if nextSymbol == .tashkeel(.kasra) {
                        _ = iterator.next()
                    }
                default: break
                }
                
            default:
                let mapped: String
                if let harf = character.harf {
                    mapped = get(.harf(harf), tashkeel: character.tashkeel)
                } else {
                    continue
                }
                out.append(mapped)
                
            }
        }
        
        return out.joined()
    }
    
    /// Normalize the text by rearranging diacritics and shadda.
    private func normalizeTashkeel(_ text: String) -> [Character] {
        var i = 0
        var characters = text.unicodeScalars.map(Character.init)
        let vowels = (Tashkeel.normalVowels + Tashkeel.tanweenVowels).map(\.rawValue)
        let shadda = Tashkeel.shadda.rawValue
        while i < characters.count {
            let currentCharacter = characters[i]
            if currentCharacter == shadda {
                if i > 0 {
                    let previousCharacter = characters[i - 1]
                    if vowels.contains(previousCharacter) {
                        characters.swapAt(i, i - 1)
                    }
                }
                // Additional normalization rules can be added here
            }
            i += 1
        }
        return characters
    }

}
