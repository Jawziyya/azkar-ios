// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Azkar
  internal static let appName = L10n.tr("Localizable", "app-name")
  /// Plural format key: "%#@items@"
  internal static func repeats(_ p1: Int) -> String {
    return L10n.tr("Localizable", "repeats", p1)
  }

  internal enum About {
    /// Russian translation, transcription, audiofiles (azkar.ru)
    internal static let azkarRU = L10n.tr("Localizable", "about.azkarRU")
    /// Source code of the app (github.com)
    internal static let sourceCode = L10n.tr("Localizable", "about.sourceCode")
    /// About
    internal static let title = L10n.tr("Localizable", "about.title")
    internal enum Credits {
      /// Animation %@
      internal static func animation(_ p1: Any) -> String {
        return L10n.tr("Localizable", "about.credits.animation", String(describing: p1))
      }
      /// Font %@
      internal static func font(_ p1: Any) -> String {
        return L10n.tr("Localizable", "about.credits.font", String(describing: p1))
      }
      /// 🎨 Graphic materials and fonts
      internal static let graphicsHeader = L10n.tr("Localizable", "about.credits.graphics-header")
      /// Image %@
      internal static func image(_ p1: Any) -> String {
        return L10n.tr("Localizable", "about.credits.image", String(describing: p1))
      }
      /// 🧱 Open source libraries
      internal static let openSourceLibrariesHeader = L10n.tr("Localizable", "about.credits.open-source-libraries-header")
      /// Font of «King Fahd Complex for the Printing of the Holy Quran»
      internal static let quranComplexFont = L10n.tr("Localizable", "about.credits.quran-complex-font")
      /// 🗃 Reference
      internal static let sourcesHeader = L10n.tr("Localizable", "about.credits.sources-header")
    }
    internal enum Studio {
      /// 🥜 Jawziyya Studio
      internal static let header = L10n.tr("Localizable", "about.studio.header")
      /// Instagram page
      internal static let instagramPage = L10n.tr("Localizable", "about.studio.instagram-page")
      /// Our Apps
      internal static let jawziyyaApps = L10n.tr("Localizable", "about.studio.jawziyya-apps")
      /// Telegram channel
      internal static let telegramChannel = L10n.tr("Localizable", "about.studio.telegram-channel")
    }
    internal enum Support {
      /// ⚒ Feedback
      internal static let header = L10n.tr("Localizable", "about.support.header")
      /// Leave a review
      internal static let leaveReview = L10n.tr("Localizable", "about.support.leave-review")
      /// Write email
      internal static let writeToEmail = L10n.tr("Localizable", "about.support.write-to-email")
    }
  }

  internal enum Alerts {
    /// Select your favorite app icon
    internal static let checkoutIconPacks = L10n.tr("Localizable", "alerts.checkout-icon-packs")
    /// Turn on notifications to receive reminders about morning and evening adhkar
    internal static let turnOnNotificationsAlert = L10n.tr("Localizable", "alerts.turn-on-notifications-alert")
  }

  internal enum Category {
    /// Adhkar after salah
    internal static let afterSalah = L10n.tr("Localizable", "category.after-salah")
    /// Evening
    internal static let evening = L10n.tr("Localizable", "category.evening")
    /// Morning
    internal static let morning = L10n.tr("Localizable", "category.morning")
    /// Important adhkar
    internal static let other = L10n.tr("Localizable", "category.other")
  }

  internal enum Common {
    /// Default
    internal static let `default` = L10n.tr("Localizable", "common.default")
    /// Restore
    internal static let restore = L10n.tr("Localizable", "common.restore")
    /// Share Azkar App
    internal static let shareApp = L10n.tr("Localizable", "common.share-app")
    /// Version
    internal static let version = L10n.tr("Localizable", "common.version")
    /// Dhikr
    internal static let zikr = L10n.tr("Localizable", "common.zikr")
  }

  internal enum Fadl {
    internal enum Source {
      /// Abu Daud
      internal static let abuDaud = L10n.tr("Localizable", "fadl.source.AbuDaud")
      /// al-Beyhaqi
      internal static let beyhaqi = L10n.tr("Localizable", "fadl.source.Beyhaqi")
      /// Sahih al-Bukhari
      internal static let bukhari = L10n.tr("Localizable", "fadl.source.Bukhari")
      /// Sahih Muslim
      internal static let muslim = L10n.tr("Localizable", "fadl.source.Muslim")
      /// Quran
      internal static let quran = L10n.tr("Localizable", "fadl.source.Quran")
    }
  }

  internal enum IconPack {
    internal enum Darsigova {
      /// Sunsets and sunrises as our faith keepers which has signs of the mercy of our Lord.
      internal static let description = L10n.tr("Localizable", "icon_pack.darsigova.description")
      /// App Icon Pack «Faith keepers»
      internal static let title = L10n.tr("Localizable", "icon_pack.darsigova.title")
    }
    internal enum Info {
      /// You have purchased this App Icon pack 🎉
      internal static let purchasedMessage = L10n.tr("Localizable", "icon_pack.info.purchased-message")
    }
    internal enum Maccinz {
      /// Soft colors, at home feeling.
      internal static let description = L10n.tr("Localizable", "icon_pack.maccinz.description")
      /// App Icon Pack «Illustrations»
      internal static let title = L10n.tr("Localizable", "icon_pack.maccinz.title")
    }
    internal enum Standard {
      ///  
      internal static let description = L10n.tr("Localizable", "icon_pack.standard.description")
      /// Standard icons pack
      internal static let title = L10n.tr("Localizable", "icon_pack.standard.title")
    }
  }

  internal enum Notifications {
    /// Evening adhkar 🌄
    internal static let eveningNotificationTitle = L10n.tr("Localizable", "notifications.evening-notification-title")
    /// Morning adhkar 🌅
    internal static let morningNotificationTitle = L10n.tr("Localizable", "notifications.morning-notification-title")
  }

  internal enum Read {
    /// narrated by
    internal static let narratedBy = L10n.tr("Localizable", "read.narrated-by")
    /// repeats
    internal static let repeats = L10n.tr("Localizable", "read.repeats")
    /// source
    internal static let source = L10n.tr("Localizable", "read.source")
    /// transliteration
    internal static let transcription = L10n.tr("Localizable", "read.transcription")
    /// translation
    internal static let translation = L10n.tr("Localizable", "read.translation")
  }

  internal enum Root {
    /// About
    internal static let about = L10n.tr("Localizable", "root.about")
    /// Please select section
    internal static let pickSection = L10n.tr("Localizable", "root.pick-section")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "root.settings")
  }

  internal enum Settings {
    /// Fun Features
    internal static let funFeatures = L10n.tr("Localizable", "settings.fun_features")
    /// Settings
    internal static let title = L10n.tr("Localizable", "settings.title")
    internal enum FunFeatures {
      /// These are features which make Azkar app a bit beautiful but some people find useless and annoying.
      internal static let description = L10n.tr("Localizable", "settings.fun_features.description")
    }
    internal enum Icon {
      /// Icon
      internal static let title = L10n.tr("Localizable", "settings.icon.title")
      internal enum List {
        /// Dark night
        internal static let darkNight = L10n.tr("Localizable", "settings.icon.list.dark_night")
        /// A moment
        internal static let darsigova1 = L10n.tr("Localizable", "settings.icon.list.darsigova_1")
        /// In the arms of the evening
        internal static let darsigova10 = L10n.tr("Localizable", "settings.icon.list.darsigova_10")
        /// Binding threads
        internal static let darsigova2 = L10n.tr("Localizable", "settings.icon.list.darsigova_2")
        /// On the edge of time
        internal static let darsigova3 = L10n.tr("Localizable", "settings.icon.list.darsigova_3")
        /// Freedom
        internal static let darsigova4 = L10n.tr("Localizable", "settings.icon.list.darsigova_4")
        /// Light in a town
        internal static let darsigova5 = L10n.tr("Localizable", "settings.icon.list.darsigova_5")
        /// Aerial moment
        internal static let darsigova6 = L10n.tr("Localizable", "settings.icon.list.darsigova_6")
        /// Shining stars in the sky
        internal static let darsigova7 = L10n.tr("Localizable", "settings.icon.list.darsigova_7")
        /// Color's fly
        internal static let darsigova8 = L10n.tr("Localizable", "settings.icon.list.darsigova_8")
        /// Tender
        internal static let darsigova9 = L10n.tr("Localizable", "settings.icon.list.darsigova_9")
        /// Gold
        internal static let gold = L10n.tr("Localizable", "settings.icon.list.gold")
        /// Inc
        internal static let ink = L10n.tr("Localizable", "settings.icon.list.ink")
        /// Sunny day
        internal static let maccinzDay = L10n.tr("Localizable", "settings.icon.list.maccinz_day")
        /// Eid vibes
        internal static let maccinzHouse = L10n.tr("Localizable", "settings.icon.list.maccinz_house")
        /// In mountains
        internal static let maccinzMountains = L10n.tr("Localizable", "settings.icon.list.maccinz_mountains")
        /// Ramadan night
        internal static let maccinzRamadanNight = L10n.tr("Localizable", "settings.icon.list.maccinz_ramadan_night")
        /// Ramadan
        internal static let ramadan = L10n.tr("Localizable", "settings.icon.list.ramadan")
      }
    }
    internal enum Notifications {
      /// Evening reminder
      internal static let eveningOptionLabel = L10n.tr("Localizable", "settings.notifications.evening-option-label")
      /// Morning reminder
      internal static let morningOptionLabel = L10n.tr("Localizable", "settings.notifications.morning-option-label")
      /// Remind about morning & evening adhkar
      internal static let switchLabel = L10n.tr("Localizable", "settings.notifications.switch-label")
      /// Notifications
      internal static let title = L10n.tr("Localizable", "settings.notifications.title")
    }
    internal enum Text {
      /// Arabic font size
      internal static let arabicTextFont = L10n.tr("Localizable", "settings.text.arabic-text-font")
      /// Text size
      internal static let fontSize = L10n.tr("Localizable", "settings.text.font-size")
      /// Show tashkeel
      internal static let showTashkeel = L10n.tr("Localizable", "settings.text.show-tashkeel")
      /// Standard iOS
      internal static let standardFontName = L10n.tr("Localizable", "settings.text.standard-font-name")
      /// Text
      internal static let title = L10n.tr("Localizable", "settings.text.title")
      /// System text size
      internal static let useSystemFontSize = L10n.tr("Localizable", "settings.text.use-system-font-size")
    }
    internal enum Theme {
      /// System
      internal static let auto = L10n.tr("Localizable", "settings.theme.auto")
      /// Color scheme
      internal static let colorScheme = L10n.tr("Localizable", "settings.theme.color-scheme")
      /// Dark
      internal static let dark = L10n.tr("Localizable", "settings.theme.dark")
      /// Light
      internal static let light = L10n.tr("Localizable", "settings.theme.light")
      /// Appearance
      internal static let title = L10n.tr("Localizable", "settings.theme.title")
      internal enum ColorTheme {
        /// Color theme
        internal static let header = L10n.tr("Localizable", "settings.theme.color-theme.header")
        /// Ink
        internal static let ink = L10n.tr("Localizable", "settings.theme.color-theme.ink")
        /// Purple Rose
        internal static let purpleRose = L10n.tr("Localizable", "settings.theme.color-theme.purple-rose")
        /// Rose Quartz
        internal static let roseQuartz = L10n.tr("Localizable", "settings.theme.color-theme.rose-quartz")
        /// Sea
        internal static let sea = L10n.tr("Localizable", "settings.theme.color-theme.sea")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

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
