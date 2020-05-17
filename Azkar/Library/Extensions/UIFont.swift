//
//  UIFont.swift
//  fawaid
//
//  Created by Abdurahim Jauzee on 06/07/2017.
//  Copyright © 2017 Al Jawziyya. All rights reserved.
//

import UIKit

public extension UIFont {

    static func systemFont(ofStyle style: UIFont.TextStyle, weight: UIFont.Weight = .regular, extra: CGFloat = 0, maxSize: CGFloat? = nil) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        var size = descriptor.pointSize + extra
        if let maxSize = maxSize {
            size = min(maxSize, size)
        }
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        return font
    }

    func scaled(_ scale: CGFloat) -> UIFont {
        return self.withSize(pointSize * scale)
    }

}

extension UIFont {

    enum FontType: String {
        case none = "", regular, bold, demibold, light, ultralight, italic, thin, roman, medium, mediumitalic, condensedMedium, condensedExtrabold, semibold, bolditalic, heavy
    }

    static func systemFont(ofType type: FontType = .regular, size: CGFloat) -> UIFont {
        if #available(iOS 8.2, *) {
            var fontType: UIFont.Weight
            switch type {
            case .bold: fontType = UIFont.Weight.bold
            case .ultralight: fontType = UIFont.Weight.ultraLight
            case .thin: fontType = UIFont.Weight.thin
            case .light: fontType = UIFont.Weight.light
            case .regular: fontType = UIFont.Weight.regular
            case .medium: fontType = UIFont.Weight.medium
            case .heavy: fontType = UIFont.Weight.heavy
            default: return UIFont.systemFont(ofSize: size)
            }
            return UIFont.systemFont(ofSize: size, weight: fontType)
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }

    enum FontFamily: String {
        case georgia = "Georgia"
        case iowan = "IowanOldStyle"
        case palatino = "Palatino"
        case times = "TimesNewRomanPS"
        case verdana = "Verdana"
        case menlo
        case avenirNext = "AvenirNext"

        static var all: [FontFamily] = [.georgia, .iowan, .palatino, .times]

        func fontName(with type: FontType) -> String {
            return rawValue + suffix(for: type)
        }

        func suffix(for type: FontType) -> String {
            switch type {
            case .regular where self == .verdana: return ""
            case .regular where self == .iowan || self == .palatino: return "-Roman"
            case .regular where self == .times: return "MT"
            case .italic where self == .times, .bold where self == .times: return "-\(type.rawValue.capitalized)MT"
            case .regular where self == .georgia: return ""
            default: return "-\(type.rawValue.capitalized)"
            }
        }

        var title: String {
            switch self {
            case .times: return "Times New Roman"
            default: return rawValue
            }
        }

    }

    static func textFont(for textStyle: UIFont.TextStyle, maxSize: CGFloat? = nil, type: FontType = .regular, sizeCategory: UIContentSizeCategory? = nil) -> UIFont {
        let descriptor: UIFontDescriptor
        if let category = sizeCategory {
            descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle, compatibleWith: UITraitCollection.init(preferredContentSizeCategory: category))
        } else {
            descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        }
        let size = maxSize ?? descriptor.pointSize
        return UIFont.customFont(of: .iowan, type: type, size: size)
    }

    static func customFont(of family: FontFamily, type: FontType, size: CGFloat) -> UIFont {
        let name = family.rawValue + family.suffix(for: type)
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofType: type, size: size)
    }

}
