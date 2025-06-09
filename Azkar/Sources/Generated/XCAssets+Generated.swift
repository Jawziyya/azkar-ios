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
  internal enum IconPreviews {
    internal static let adhkar = ImageAsset(name: "IconPreviews/adhkar")
    internal static let crescent = ImageAsset(name: "IconPreviews/crescent")
    internal static let gold = ImageAsset(name: "IconPreviews/gold")
    internal static let ink = ImageAsset(name: "IconPreviews/ink")
    internal static let light = ImageAsset(name: "IconPreviews/light")
    internal static let midjourney001 = ImageAsset(name: "IconPreviews/midjourney001")
    internal static let serpentine = ImageAsset(name: "IconPreviews/serpentine")
    internal static let spring = ImageAsset(name: "IconPreviews/spring")
    internal static let vibrantMoon = ImageAsset(name: "IconPreviews/vibrantMoon")
  }
  internal enum Patterns {
    internal static let blueGradient = ImageAsset(name: "Patterns/blue-gradient")
    internal static let gradientYellowToBlue = ImageAsset(name: "Patterns/gradient-yellow-to-blue")
    internal static let paper = ImageAsset(name: "Patterns/paper")
    internal static let paper2 = ImageAsset(name: "Patterns/paper2")
  }
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
  internal enum Categories {
    internal static let afterSalah = ImageAsset(name: "categories/after-salah")
    internal static let evening = ImageAsset(name: "categories/evening")
    internal static let hundredDua = ImageAsset(name: "categories/hundred-dua")
    internal static let importantAdhkar = ImageAsset(name: "categories/important-adhkar")
    internal static let morning = ImageAsset(name: "categories/morning")
    internal static let night = ImageAsset(name: "categories/night")
  }
  internal static let completionEveningBackground = ImageAsset(name: "completion-evening-background")
  internal static let completionEveningBg = ColorAsset(name: "completion-evening-bg")
  internal static let completionEvening = ImageAsset(name: "completion-evening")
  internal static let completionSun = ImageAsset(name: "completion-sun")
  internal static let gemStone = ImageAsset(name: "gem-stone")
  internal static let eidBackground = ImageAsset(name: "eid_background")
  internal static let mosque = ImageAsset(name: "mosque")
  internal static let inkIcon = ImageAsset(name: "ink-icon")
  internal static let lockDynamicColor = ImageAsset(name: "lock-dynamic-color")
  internal enum MoonPhase {
    internal static let firstQuarter = ImageAsset(name: "moon-phase/first-quarter")
    internal static let fullMoon = ImageAsset(name: "moon-phase/full-moon")
    internal static let lastQuarter = ImageAsset(name: "moon-phase/last-quarter")
    internal static let newMoon = ImageAsset(name: "moon-phase/new-moon")
    internal static let waningCrescent = ImageAsset(name: "moon-phase/waning-crescent")
    internal static let waningGibbous = ImageAsset(name: "moon-phase/waning-gibbous")
    internal static let waxingCrescent = ImageAsset(name: "moon-phase/waxing-crescent")
    internal static let waxingGibbous = ImageAsset(name: "moon-phase/waxing-gibbous")
  }
  internal enum MoonPhaseBlue {
    internal static let firstQuarter = ImageAsset(name: "moon-phase-blue/first-quarter")
    internal static let fullMoon = ImageAsset(name: "moon-phase-blue/full-moon")
    internal static let lastQuarter = ImageAsset(name: "moon-phase-blue/last-quarter")
    internal static let newMoon = ImageAsset(name: "moon-phase-blue/new-moon")
    internal static let waningCrescent = ImageAsset(name: "moon-phase-blue/waning-crescent")
    internal static let waningGibbous = ImageAsset(name: "moon-phase-blue/waning-gibbous")
    internal static let waxingCrescent = ImageAsset(name: "moon-phase-blue/waxing-crescent")
    internal static let waxingGibbous = ImageAsset(name: "moon-phase-blue/waxing-gibbous")
  }
  internal enum MoonPhases {
    internal static let firstQuarter = ImageAsset(name: "moon-phases/first-quarter")
    internal static let fullMoon = ImageAsset(name: "moon-phases/full-moon")
    internal static let lastQuarter = ImageAsset(name: "moon-phases/last-quarter")
    internal static let newMoon = ImageAsset(name: "moon-phases/new-moon")
    internal static let waningCrescent = ImageAsset(name: "moon-phases/waning-crescent")
    internal static let waningGibbous = ImageAsset(name: "moon-phases/waning-gibbous")
    internal static let waxingCrescent = ImageAsset(name: "moon-phases/waxing-crescent")
    internal static let waxingGibbous = ImageAsset(name: "moon-phases/waxing-gibbous")
  }
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
