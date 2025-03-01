// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accent = ColorAsset(name: "accent")
  internal static let background = ColorAsset(name: "background")
  internal static let contentBackground = ColorAsset(name: "contentBackground")
  internal static let secondaryBackground = ColorAsset(name: "secondaryBackground")
  internal static let secondaryText = ColorAsset(name: "secondaryText")
  internal static let tertiaryText = ColorAsset(name: "tertiaryText")
  internal static let text = ColorAsset(name: "text")
  internal enum AppThemes {
    internal enum Code {
      internal static let accent = ColorAsset(name: "AppThemes/Code/accent")
      internal static let background = ColorAsset(name: "AppThemes/Code/background")
      internal static let contentBackground = ColorAsset(name: "AppThemes/Code/contentBackground")
      internal static let secondaryBackground = ColorAsset(name: "AppThemes/Code/secondaryBackground")
      internal static let secondaryText = ColorAsset(name: "AppThemes/Code/secondaryText")
      internal static let tertiaryText = ColorAsset(name: "AppThemes/Code/tertiaryText")
      internal static let text = ColorAsset(name: "AppThemes/Code/text")
    }
    internal enum Flat {
      internal static let evening = ImageAsset(name: "AppThemes/Flat/evening")
      internal static let morning = ImageAsset(name: "AppThemes/Flat/morning")
    }
    internal enum Neomorphic {
      internal static let accent = ColorAsset(name: "AppThemes/Neomorphic/accent")
      internal static let background = ColorAsset(name: "AppThemes/Neomorphic/background")
      internal static let contentBackground = ColorAsset(name: "AppThemes/Neomorphic/contentBackground")
      internal static let evening = ImageAsset(name: "AppThemes/Neomorphic/evening")
      internal static let morning = ImageAsset(name: "AppThemes/Neomorphic/morning")
      internal static let secondaryText = ColorAsset(name: "AppThemes/Neomorphic/secondaryText")
      internal static let text = ColorAsset(name: "AppThemes/Neomorphic/text")
    }
    internal enum Reader {
      internal static let accent = ColorAsset(name: "AppThemes/Reader/accent")
      internal static let background = ColorAsset(name: "AppThemes/Reader/background")
      internal static let contentBackground = ColorAsset(name: "AppThemes/Reader/contentBackground")
      internal static let evening = ImageAsset(name: "AppThemes/Reader/evening")
      internal static let morning = ImageAsset(name: "AppThemes/Reader/morning")
      internal static let secondaryText = ColorAsset(name: "AppThemes/Reader/secondaryText")
      internal static let text = ColorAsset(name: "AppThemes/Reader/text")
    }
  }
  internal enum ColorThemes {
    internal enum Forest {
      internal static let accent = ColorAsset(name: "ColorThemes/Forest/accent")
      internal static let background = ColorAsset(name: "ColorThemes/Forest/background")
      internal static let contentBackground = ColorAsset(name: "ColorThemes/Forest/contentBackground")
    }
    internal enum Ink {
      internal static let accent = ColorAsset(name: "ColorThemes/Ink/accent")
      internal static let background = ColorAsset(name: "ColorThemes/Ink/background")
      internal static let contentBackground = ColorAsset(name: "ColorThemes/Ink/contentBackground")
    }
    internal enum PurpleRose {
      internal static let accent = ColorAsset(name: "ColorThemes/PurpleRose/accent")
      internal static let background = ColorAsset(name: "ColorThemes/PurpleRose/background")
      internal static let contentBackground = ColorAsset(name: "ColorThemes/PurpleRose/contentBackground")
    }
    internal enum RoseQuartz {
      internal static let accent = ColorAsset(name: "ColorThemes/RoseQuartz/accent")
      internal static let background = ColorAsset(name: "ColorThemes/RoseQuartz/background")
      internal static let contentBackground = ColorAsset(name: "ColorThemes/RoseQuartz/contentBackground")
    }
    internal enum Sea {
      internal static let accent = ColorAsset(name: "ColorThemes/Sea/accent")
      internal static let background = ColorAsset(name: "ColorThemes/Sea/background")
      internal static let contentBackground = ColorAsset(name: "ColorThemes/Sea/contentBackground")
    }
  }
  internal static let touchImageBlue = ImageAsset(name: "TouchImageBlue")
  internal enum ZikrCollectionsOnboarding {
    internal static let cardFileBox = ImageAsset(name: "ZikrCollectionsOnboarding/card-file-box")
    internal static let confetti = ImageAsset(name: "ZikrCollectionsOnboarding/confetti")
    internal static let header = ImageAsset(name: "ZikrCollectionsOnboarding/header")
    internal static let paperAndMagnifier = ImageAsset(name: "ZikrCollectionsOnboarding/paper-and-magnifier")
  }
  internal static let azkarGoldLogo = ImageAsset(name: "azkar-gold-logo")
  internal static let flash = ImageAsset(name: "flash")
  internal static let gemStone = ImageAsset(name: "gem-stone")
  internal static let eidBackground = ImageAsset(name: "eid_background")
  internal static let mosque = ImageAsset(name: "mosque")
  internal static let lock = ImageAsset(name: "lock")
  internal static let premiumGem = ImageAsset(name: "premium-gem")
  internal static let premiumLock = ImageAsset(name: "premium-lock")
  internal static let proUserTag = ImageAsset(name: "pro-user-tag")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
