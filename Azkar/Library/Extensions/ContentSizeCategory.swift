//
//  ContentSizeCategory.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 12.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import SwiftUI

extension ContentSizeCategory: PickableItem { }

extension ContentSizeCategory: Codable {

    var uiContentSizeCategory: UIContentSizeCategory {
        switch self {
        case .extraSmall: return .extraSmall
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        case .extraLarge: return .extraLarge
        case .extraExtraLarge: return .extraExtraLarge
        case .extraExtraExtraLarge: return .extraExtraExtraLarge
        case .accessibilityMedium: return .accessibilityMedium
        case .accessibilityLarge: return .accessibilityLarge
        case .accessibilityExtraLarge: return .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge: return .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge: return .accessibilityExtraExtraExtraLarge
        @unknown default: return .medium
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let float = try container.decode(CGFloat.self)
        self = .init(floatValue: float)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(floatValue)
    }

    static var stride: CGFloat {
        return 1 / CGFloat(allCases.count - 1)
    }

    var floatValue: CGFloat {
        let index = CGFloat(ContentSizeCategory.allCases.firstIndex(of: self) ?? 0)
        return index * ContentSizeCategory.stride
    }

    init(floatValue: CGFloat) {
        let index = Int(round(floatValue / ContentSizeCategory.stride))
        self = ContentSizeCategory.allCases[index]
    }

    var name: String {
        switch self {
        case .extraSmall: return "XS"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
        case .extraLarge: return "XL"
        case .extraExtraLarge: return "XXL"
        case .extraExtraExtraLarge: return "XXXL"
        case .accessibilityMedium: return "M+"
        case .accessibilityLarge: return "L+"
        case .accessibilityExtraLarge: return "XL+"
        case .accessibilityExtraExtraLarge: return "XXL+"
        case .accessibilityExtraExtraExtraLarge: return "XXXL+"
        @unknown default: return "Unknown"
        }
    }

    var title: String {
        switch self {
        case .small: return "Мелкий"
        case .medium: return "Средний"
        case .large: return "Крупный"
        case .extraLarge: return "Большой"
        case .extraExtraExtraLarge: return "Огромный"
        default: return name
        }
    }

    static var availableCases: [Self] {
        return [
            .small,
            .medium,
            .large,
            .extraLarge,
            .extraExtraExtraLarge
        ]
    }

}
