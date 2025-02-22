import Foundation

final class ArabicText: Sequence {
    
    var head: Node?
    var tail: Node?
    var count = 0
    
    init(text: String) {
        for scalar in text.unicodeScalars {
            enqueue(Character(scalar))
        }
    }
    
    /// Enqueue a character into the linked list
    func enqueue(_ element: Character) {
        let newNode = Node(element: element)
        if let tailNode = tail {
            tailNode.next = newNode
            newNode.prev = tailNode
        } else {
            head = newNode
        }
        tail = newNode
        count += 1
    }
    
    /// Create an ArabicTextChar from a node
    func makePosition(_ node: Node?) -> ArabicTextChar? {
        guard let node = node else { return nil }
        return ArabicTextChar(parent: self, node: node)
    }
    
    /// Get the first character
    func first() -> ArabicTextChar? {
        return makePosition(head)
    }
    
    /// Get the character after a given position
    func after(_ p: ArabicTextChar) -> ArabicTextChar? {
        return makePosition(p.node.next)
    }
    
    /// Get the character before a given position
    func before(_ p: ArabicTextChar) -> ArabicTextChar? {
        return makePosition(p.node.prev)
    }
    
    /// Make the ArabicText iterable
    func makeIterator() -> ArabicTextIterator {
        return ArabicTextIterator(self)
    }
    
}

struct ArabicTextIterator: IteratorProtocol {
    var current: ArabicTextChar?
    weak var text: ArabicText?
    
    init(_ text: ArabicText) {
        self.text = text
        self.current = text.first()
    }
    
    mutating func next() -> ArabicTextChar? {
        defer {
            if let currentChar = current {
                current = text?.after(currentChar)
            }
        }
        return current
    }
}

final class Node {
    var element: Character
    var next: Node?
    var prev: Node?
    
    init(element: Character) {
        self.element = element
    }
}

/// Class representing a character and its position
final class ArabicTextChar {
    weak var parent: ArabicText?
    
    var node: Node
    
    var symbolType: SymbolType? {
        if let harf {
            return .harf(harf)
        } else if let tashkeel {
            return .tashkeel(tashkeel)
        } else if let harfExtension {
            return .harfExtension(harfExtension)
        } else if let specialCharacter = SpecialCharacter(rawValue: node.element) {
            return .special(specialCharacter)
        }
        return nil
    }
    
    var harf: Harf? {
        Harf(rawValue: node.element)
    }
    
    var harfExtension: HarfExtension? {
        HarfExtension(rawValue: node.element)
    }
    
    var tashkeel: Tashkeel? {
        Tashkeel(rawValue: node.element)
    }
    
    var character: Character {
        node.element
    }
    
    init(parent: ArabicText, node: Node) {
        self.parent = parent
        self.node = node
    }
    
    func next(_ val: Int = 1) -> ArabicTextChar? {
        var currentNode = node
        var steps = val
        while steps > 0 {
            if let nextNode = currentNode.next {
                currentNode = nextNode
            } else {
                return nil
            }
            steps -= 1
        }
        return parent?.makePosition(currentNode)
    }
    
    func prev(_ val: Int = 1) -> ArabicTextChar? {
        var currentNode = node
        var steps = val
        while steps > 0 {
            if let prevNode = currentNode.prev {
                currentNode = prevNode
            } else {
                return nil
            }
            steps -= 1
        }
        return parent?.makePosition(currentNode)
    }
    
    func isBlank() -> Bool {
        character == " "
    }
    
    func isStart() -> Bool {
        node.prev == nil
    }
    
    func isMid() -> Bool {
        !isStart() && next()?.isBlank() != true
    }
    
    func isEndOfLine() -> Bool {
        node.next?.element == "\n" || isEnd()
    }
    
    func isEnd() -> Bool {
        node.next == nil
    }
    
    func isWordStart() -> Bool {
        prev()?.isBlank() == true
    }
    
    func preceeded(_ n: Int) -> String {
        var result = ""
        var currentChar: ArabicTextChar? = self
        var steps = n
        while steps > 0 {
            if let prevChar = currentChar?.prev() {
                result.append(prevChar.character)
                currentChar = prevChar
            } else {
                break
            }
            steps -= 1
        }
        return result
    }
    
    func succeeded(_ n: Int) -> String {
        var result = ""
        var currentChar: ArabicTextChar? = self
        var steps = n
        while steps > 0 {
            if let nextChar = currentChar?.next() {
                result.append(nextChar.character)
                currentChar = nextChar
            } else {
                break
            }
            steps -= 1
        }
        return result
    }
    
    func isFollowedByShadda() -> Bool {
        next()?.tashkeel == .shadda
    }
    
    func isFathaFollowedByAlif() -> Bool {
        tashkeel == .fatha && (next()?.harf == .alif || next()?.harfExtension == .alifKhanjareeya)
    }
    
    func isKasraFollowedByYa() -> Bool {
        tashkeel == .kasra && (next()?.harf == .ya && next()?.next()?.tashkeel == nil)
    }
    
    func isKasraPreceededByAlifWithHamzaBelow() -> Bool {
        prev()?.harfExtension == .alifHamzaBelow
    }
    
    func isDammaFollowedByWaw() -> Bool {
        tashkeel == .damma && next()?.harf == .waw && next()?.next()?.harf != nil
    }
    
    func isFollowedBySun() -> Bool {
        next()?.next()?.isFollowedByShadda() == true
    }
    
}
