import Foundation

public enum ZikrCollectionSource: String, Codable, Identifiable, Hashable, CaseIterable {
    case hisnulMuslim = "hisn"
    case azkarRU = "azkar_ru"
    
    public var id: Self {
        self
    }

    public var title: String {
        let localizationKey: String
        switch self {
        case .hisnulMuslim: localizationKey = "adhkar-collections.hisn.title"
        case .azkarRU: localizationKey = "adhkar-collections.azkar-ru.title"
        }
        return NSLocalizedString(localizationKey, comment: "")
    }
    
    public var shortTitle: String? {
        let localizationKey: String
        switch self {
        case .hisnulMuslim: localizationKey = "adhkar-collections.hisn.short-title"
        case .azkarRU: return nil
        }
        return NSLocalizedString(localizationKey, comment: "")
    }
    
    public var description: String {
        let localizationKey: String
        switch self {
        case .hisnulMuslim: localizationKey = "adhkar-collections.hisn.description"
        case .azkarRU: localizationKey = "adhkar-collections.azkar-ru.description"
        }
        return NSLocalizedString(localizationKey, comment: "")
    }
}

public struct ZikrCollectionData: Codable {
    public let id: Int
    public let category: ZikrCategory
    public let azkarIds: [Int]
    public let source: ZikrCollectionSource
    
    public init(
        id: Int,
        category: ZikrCategory,
        azkarIds: [Int],
        source: ZikrCollectionSource
    ) {
        self.id = id
        self.category = category
        self.azkarIds = azkarIds
        self.source = source
    }
}
