// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Azkar
  internal static let appName = L10n.tr("Localizable", "app-name", fallback: "Azkar")
  /// Plural format key: "%#@items@"
  internal static func remainingRepeats(_ p1: Int) -> String {
    return L10n.tr("Localizable", "remaining-repeats", p1, fallback: "Plural format key: \"%#@items@\"")
  }
  /// Plural format key: "%#@items@"
  internal static func repeats(_ p1: Int) -> String {
    return L10n.tr("Localizable", "repeats", p1, fallback: "Plural format key: \"%#@items@\"")
  }
  internal enum About {
    /// About
    internal static let title = L10n.tr("Localizable", "about.title", fallback: "About")
    internal enum Credits {
      /// Font %@
      internal static func font(_ p1: Any) -> String {
        return L10n.tr("Localizable", "about.credits.font", String(describing: p1), fallback: "Font %@")
      }
      /// Image %@
      internal static func image(_ p1: Any) -> String {
        return L10n.tr("Localizable", "about.credits.image", String(describing: p1), fallback: "Image %@")
      }
    }
    internal enum Support {
      /// ⚒ Feedback
      internal static let header = L10n.tr("Localizable", "about.support.header", fallback: "⚒ Feedback")
      /// Leave a review
      internal static let leaveReview = L10n.tr("Localizable", "about.support.leave-review", fallback: "Leave a review")
      /// Write email
      internal static let writeToEmail = L10n.tr("Localizable", "about.support.write-to-email", fallback: "Write email")
    }
  }
  internal enum Alerts {
    /// Select your favorite app icon
    internal static let checkoutIconPacks = L10n.tr("Localizable", "alerts.checkout-icon-packs", fallback: "Select your favorite app icon")
    /// Turn on notifications to receive reminders about morning and evening adhkar
    internal static let turnOnNotificationsAlert = L10n.tr("Localizable", "alerts.turn-on-notifications-alert", fallback: "Turn on notifications to receive reminders about morning and evening adhkar")
  }
  internal enum Category {
    /// Adhkar after salah
    internal static let afterSalah = L10n.tr("Localizable", "category.after-salah", fallback: "Adhkar after salah")
    /// Evening
    internal static let evening = L10n.tr("Localizable", "category.evening", fallback: "Evening")
    /// Morning
    internal static let morning = L10n.tr("Localizable", "category.morning", fallback: "Morning")
    /// Bedtime
    internal static let night = L10n.tr("Localizable", "category.night", fallback: "Bedtime")
    /// Important adhkar
    internal static let other = L10n.tr("Localizable", "category.other", fallback: "Important adhkar")
  }
  internal enum Common {
    /// Continue
    internal static let `continue` = L10n.tr("Localizable", "common.continue", fallback: "Continue")
    /// Default
    internal static let `default` = L10n.tr("Localizable", "common.default", fallback: "Default")
    /// Done
    internal static let done = L10n.tr("Localizable", "common.done", fallback: "Done")
    /// Enable
    internal static let enable = L10n.tr("Localizable", "common.enable", fallback: "Enable")
    /// No search results
    internal static let noSearchResults = L10n.tr("Localizable", "common.no-search-results", fallback: "No search results")
    /// Report a problem
    internal static let reportProblem = L10n.tr("Localizable", "common.report-problem", fallback: "Report a problem")
    /// Restore
    internal static let restore = L10n.tr("Localizable", "common.restore", fallback: "Restore")
    /// Send
    internal static let send = L10n.tr("Localizable", "common.send", fallback: "Send")
    /// Share
    internal static let share = L10n.tr("Localizable", "common.share", fallback: "Share")
    /// Share Azkar App
    internal static let shareApp = L10n.tr("Localizable", "common.share-app", fallback: "Share Azkar App")
    /// Version
    internal static let version = L10n.tr("Localizable", "common.version", fallback: "Version")
    /// Dhikr
    internal static let zikr = L10n.tr("Localizable", "common.zikr", fallback: "Dhikr")
  }
  internal enum Credits {
    /// Animation %@
    internal static func animation(_ p1: Any) -> String {
      return L10n.tr("Localizable", "credits.animation", String(describing: p1), fallback: "Animation %@")
    }
    /// Russian translation, transcription, audiofiles (azkar.ru)
    internal static let azkarRu = L10n.tr("Localizable", "credits.azkar-ru", fallback: "Russian translation, transcription, audiofiles (azkar.ru)")
    /// ✏️ Fonts
    internal static let fonts = L10n.tr("Localizable", "credits.fonts", fallback: "✏️ Fonts")
    /// 🎨 Graphic materials and fonts
    internal static let graphics = L10n.tr("Localizable", "credits.graphics", fallback: "🎨 Graphic materials and fonts")
    /// 🧱 Open source libraries
    internal static let libraries = L10n.tr("Localizable", "credits.libraries", fallback: "🧱 Open source libraries")
    /// 🥜 Jawziyya Studio
    internal static let links = L10n.tr("Localizable", "credits.links", fallback: "🥜 Jawziyya Studio")
    /// 🗃 Reference
    internal static let materials = L10n.tr("Localizable", "credits.materials", fallback: "🗃 Reference")
    /// Font of «King Fahd Complex for the Printing of the Holy Quran»
    internal static let quranComplexFont = L10n.tr("Localizable", "credits.quran-complex-font", fallback: "Font of «King Fahd Complex for the Printing of the Holy Quran»")
    /// 🔊 Sounds
    internal static let sounds = L10n.tr("Localizable", "credits.sounds", fallback: "🔊 Sounds")
    /// Source code of the app (github.com)
    internal static let sourceCode = L10n.tr("Localizable", "credits.source-code", fallback: "Source code of the app (github.com)")
    internal enum Studio {
      /// Instagram page
      internal static let instagramPage = L10n.tr("Localizable", "credits.studio.instagram-page", fallback: "Instagram page")
      /// Our Apps
      internal static let jawziyyaApps = L10n.tr("Localizable", "credits.studio.jawziyya-apps", fallback: "Our Apps")
      /// Telegram channel
      internal static let telegramChannel = L10n.tr("Localizable", "credits.studio.telegram-channel", fallback: "Telegram channel")
    }
  }
  internal enum Fadl {
    internal enum Source {
      /// Abu Daud
      internal static let abuDaud = L10n.tr("Localizable", "fadl.source.AbuDaud", fallback: "Abu Daud")
      /// al-Beyhaqi
      internal static let beyhaqi = L10n.tr("Localizable", "fadl.source.Beyhaqi", fallback: "al-Beyhaqi")
      /// Sahih al-Bukhari
      internal static let bukhari = L10n.tr("Localizable", "fadl.source.Bukhari", fallback: "Sahih al-Bukhari")
      /// Sahih Muslim
      internal static let muslim = L10n.tr("Localizable", "fadl.source.Muslim", fallback: "Sahih Muslim")
      /// Quran
      internal static let quran = L10n.tr("Localizable", "fadl.source.Quran", fallback: "Quran")
    }
  }
  internal enum Fonts {
    /// System font
    internal static let standardFont = L10n.tr("Localizable", "fonts.standard-font", fallback: "System font")
    /// Fonts
    internal static let title = L10n.tr("Localizable", "fonts.title", fallback: "Fonts")
    internal enum Arabic {
      /// Some fonts do not support displaying Arabic language vowels. Please look at the sample image to determine which font supports vowels.
      internal static let info = L10n.tr("Localizable", "fonts.arabic.info", fallback: "Some fonts do not support displaying Arabic language vowels. Please look at the sample image to determine which font supports vowels.")
    }
    internal enum `Type` {
      /// Decorative
      internal static let decorative = L10n.tr("Localizable", "fonts.type.decorative", fallback: "Decorative")
      /// Handwritten
      internal static let handwritten = L10n.tr("Localizable", "fonts.type.handwritten", fallback: "Handwritten")
      /// Sans Serif
      internal static let sansSerif = L10n.tr("Localizable", "fonts.type.sansSerif", fallback: "Sans Serif")
      /// Serif
      internal static let serif = L10n.tr("Localizable", "fonts.type.serif", fallback: "Serif")
      /// Standard
      internal static let standard = L10n.tr("Localizable", "fonts.type.standard", fallback: "Standard")
      internal enum Arabic {
        /// Kufi
        internal static let kufi = L10n.tr("Localizable", "fonts.type.arabic.kufi", fallback: "Kufi")
        /// Maghribi
        internal static let maghribi = L10n.tr("Localizable", "fonts.type.arabic.maghribi", fallback: "Maghribi")
        /// Modern
        internal static let modern = L10n.tr("Localizable", "fonts.type.arabic.modern", fallback: "Modern")
        /// Naskh
        internal static let naskh = L10n.tr("Localizable", "fonts.type.arabic.naskh", fallback: "Naskh")
        /// Other
        internal static let other = L10n.tr("Localizable", "fonts.type.arabic.other", fallback: "Other")
        /// Riqa
        internal static let riqa = L10n.tr("Localizable", "fonts.type.arabic.riqa", fallback: "Riqa")
        /// Thuluth
        internal static let thuluth = L10n.tr("Localizable", "fonts.type.arabic.thuluth", fallback: "Thuluth")
      }
    }
  }
  internal enum IconPack {
    internal enum Darsigova {
      /// Sunsets and sunrises as our faith keepers which has signs of the mercy of our Lord.
      internal static let description = L10n.tr("Localizable", "icon_pack.darsigova.description", fallback: "Sunsets and sunrises as our faith keepers which has signs of the mercy of our Lord.")
      /// App Icon Pack «Faith keepers»
      internal static let title = L10n.tr("Localizable", "icon_pack.darsigova.title", fallback: "App Icon Pack «Faith keepers»")
    }
    internal enum Info {
      /// You have purchased this App Icon pack 🎉
      internal static let purchasedMessage = L10n.tr("Localizable", "icon_pack.info.purchased-message", fallback: "You have purchased this App Icon pack 🎉")
    }
    internal enum Maccinz {
      /// Soft colors, at home feeling.
      internal static let description = L10n.tr("Localizable", "icon_pack.maccinz.description", fallback: "Soft colors, at home feeling.")
      /// App Icon Pack «Illustrations»
      internal static let title = L10n.tr("Localizable", "icon_pack.maccinz.title", fallback: "App Icon Pack «Illustrations»")
    }
    internal enum Standard {
      ///  
      internal static let description = L10n.tr("Localizable", "icon_pack.standard.description", fallback: " ")
      /// Standard icons pack
      internal static let title = L10n.tr("Localizable", "icon_pack.standard.title", fallback: "Standard icons pack")
    }
  }
  internal enum Notifications {
    /// Evening adhkar 🌄
    internal static let eveningNotificationTitle = L10n.tr("Localizable", "notifications.evening-notification-title", fallback: "Evening adhkar 🌄")
    /// Morning adhkar 🌅
    internal static let morningNotificationTitle = L10n.tr("Localizable", "notifications.morning-notification-title", fallback: "Morning adhkar 🌅")
    internal enum Jumua {
      /// 
      internal static let body = L10n.tr("Localizable", "notifications.jumua.body", fallback: "")
      /// Dua in Jumua day
      internal static let title = L10n.tr("Localizable", "notifications.jumua.title", fallback: "Dua in Jumua day")
    }
  }
  internal enum Read {
    /// narrated by
    internal static let narratedBy = L10n.tr("Localizable", "read.narrated-by", fallback: "narrated by")
    /// repeats
    internal static let repeats = L10n.tr("Localizable", "read.repeats", fallback: "repeats")
    /// source
    internal static let source = L10n.tr("Localizable", "read.source", fallback: "source")
    /// transliteration
    internal static let transcription = L10n.tr("Localizable", "read.transcription", fallback: "transliteration")
    /// translation
    internal static let translation = L10n.tr("Localizable", "read.translation", fallback: "translation")
  }
  internal enum Root {
    /// About
    internal static let about = L10n.tr("Localizable", "root.about", fallback: "About")
    /// Please select section
    internal static let pickSection = L10n.tr("Localizable", "root.pick-section", fallback: "Please select section")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "root.settings", fallback: "Settings")
  }
  internal enum Settings {
    /// Settings
    internal static let title = L10n.tr("Localizable", "settings.title", fallback: "Settings")
    /// Fun Features
    internal static let useFunFeatures = L10n.tr("Localizable", "settings.use_fun_features", fallback: "Fun Features")
    /// These are features which make Azkar app a bit beautiful but some people find useless and annoying.
    internal static let useFunFeaturesTip = L10n.tr("Localizable", "settings.use_fun_features_tip", fallback: "These are features which make Azkar app a bit beautiful but some people find useless and annoying.")
    internal enum Breaks {
      /// If enabled, Azkar will insert line-breaks after each sentence in dhikr/dua.
      internal static let info = L10n.tr("Localizable", "settings.breaks.info", fallback: "If enabled, Azkar will insert line-breaks after each sentence in dhikr/dua.")
      /// Use smart line-breaks
      internal static let title = L10n.tr("Localizable", "settings.breaks.title", fallback: "Use smart line-breaks")
    }
    internal enum Counter {
      /// Enable counter haptic feedback
      internal static let counterHaptics = L10n.tr("Localizable", "settings.counter.counter-haptics", fallback: "Enable counter haptic feedback")
      /// Size of counter
      internal static let counterSizeTitle = L10n.tr("Localizable", "settings.counter.counter-size-title", fallback: "Size of counter")
      /// Enable counter ticker sound
      internal static let counterTicker = L10n.tr("Localizable", "settings.counter.counter-ticker", fallback: "Enable counter ticker sound")
      /// Counter type
      internal static let counterType = L10n.tr("Localizable", "settings.counter.counter-type", fallback: "Counter type")
      /// Button
      internal static let counterTypeButton = L10n.tr("Localizable", "settings.counter.counter-type-button", fallback: "Button")
      /// This option allows you to switch type of the counter used.
      /// 
      /// If you choose 'button' Azkar will display a button at the bottom of reading screen. If you choose 'tap' there will be no visible indication, but you will be able to tap twice at any area to decrement the counter.
      internal static let counterTypeInfo = L10n.tr("Localizable", "settings.counter.counter-type-info", fallback: "This option allows you to switch type of the counter used.\n\nIf you choose 'button' Azkar will display a button at the bottom of reading screen. If you choose 'tap' there will be no visible indication, but you will be able to tap twice at any area to decrement the counter.")
      /// Tap
      internal static let counterTypeTap = L10n.tr("Localizable", "settings.counter.counter-type-tap", fallback: "Tap")
      /// Go to next dhikr when repeats completed
      internal static let goToNextDhikr = L10n.tr("Localizable", "settings.counter.go-to-next-dhikr", fallback: "Go to next dhikr when repeats completed")
      /// If this option is enabled whenever you finish repeating a dhikr Azkar will show the next one
      internal static let goToNextDhikrTip = L10n.tr("Localizable", "settings.counter.go-to-next-dhikr-tip", fallback: "If this option is enabled whenever you finish repeating a dhikr Azkar will show the next one")
      /// Fine-tuning adhkar counter
      internal static let subtitle = L10n.tr("Localizable", "settings.counter.subtitle", fallback: "Fine-tuning adhkar counter")
      /// Counter
      internal static let title = L10n.tr("Localizable", "settings.counter.title", fallback: "Counter")
    }
    internal enum Icon {
      /// Icon
      internal static let title = L10n.tr("Localizable", "settings.icon.title", fallback: "Icon")
      internal enum List {
        /// Dark night
        internal static let darkNight = L10n.tr("Localizable", "settings.icon.list.dark_night", fallback: "Dark night")
        /// A moment
        internal static let darsigova1 = L10n.tr("Localizable", "settings.icon.list.darsigova_1", fallback: "A moment")
        /// In the arms of the evening
        internal static let darsigova10 = L10n.tr("Localizable", "settings.icon.list.darsigova_10", fallback: "In the arms of the evening")
        /// Binding threads
        internal static let darsigova2 = L10n.tr("Localizable", "settings.icon.list.darsigova_2", fallback: "Binding threads")
        /// On the edge of time
        internal static let darsigova3 = L10n.tr("Localizable", "settings.icon.list.darsigova_3", fallback: "On the edge of time")
        /// Freedom
        internal static let darsigova4 = L10n.tr("Localizable", "settings.icon.list.darsigova_4", fallback: "Freedom")
        /// Light in a town
        internal static let darsigova5 = L10n.tr("Localizable", "settings.icon.list.darsigova_5", fallback: "Light in a town")
        /// Aerial moment
        internal static let darsigova6 = L10n.tr("Localizable", "settings.icon.list.darsigova_6", fallback: "Aerial moment")
        /// Shining stars in the sky
        internal static let darsigova7 = L10n.tr("Localizable", "settings.icon.list.darsigova_7", fallback: "Shining stars in the sky")
        /// Color's fly
        internal static let darsigova8 = L10n.tr("Localizable", "settings.icon.list.darsigova_8", fallback: "Color's fly")
        /// Tender
        internal static let darsigova9 = L10n.tr("Localizable", "settings.icon.list.darsigova_9", fallback: "Tender")
        /// Gold
        internal static let gold = L10n.tr("Localizable", "settings.icon.list.gold", fallback: "Gold")
        /// Ink
        internal static let ink = L10n.tr("Localizable", "settings.icon.list.ink", fallback: "Ink")
        /// Sunny day
        internal static let maccinzDay = L10n.tr("Localizable", "settings.icon.list.maccinz_day", fallback: "Sunny day")
        /// Eid vibes
        internal static let maccinzHouse = L10n.tr("Localizable", "settings.icon.list.maccinz_house", fallback: "Eid vibes")
        /// In mountains
        internal static let maccinzMountains = L10n.tr("Localizable", "settings.icon.list.maccinz_mountains", fallback: "In mountains")
        /// Ramadan night
        internal static let maccinzRamadanNight = L10n.tr("Localizable", "settings.icon.list.maccinz_ramadan_night", fallback: "Ramadan night")
        /// 
        internal static let midjourney001 = L10n.tr("Localizable", "settings.icon.list.midjourney001", fallback: "")
        /// Ramadan
        internal static let ramadan = L10n.tr("Localizable", "settings.icon.list.ramadan", fallback: "Ramadan")
      }
    }
    internal enum Reminders {
      /// Enable reminders
      internal static let enable = L10n.tr("Localizable", "settings.reminders.enable", fallback: "Enable reminders")
      /// Configuration
      internal static let header = L10n.tr("Localizable", "settings.reminders.header", fallback: "Configuration")
      /// Reminder types
      internal static let reminderTypesSectionTitle = L10n.tr("Localizable", "settings.reminders.reminder-types-section-title", fallback: "Reminder types")
      /// Morning and evening adhkar reminders
      internal static let subtitle = L10n.tr("Localizable", "settings.reminders.subtitle", fallback: "Morning and evening adhkar reminders")
      /// Time
      internal static let time = L10n.tr("Localizable", "settings.reminders.time", fallback: "Time")
      /// Reminders
      internal static let title = L10n.tr("Localizable", "settings.reminders.title", fallback: "Reminders")
      internal enum Jumua {
        /// Jumua supplication
        internal static let label = L10n.tr("Localizable", "settings.reminders.jumua.label", fallback: "Jumua supplication")
        /// Remind about dua in Jumua
        internal static let switchLabel = L10n.tr("Localizable", "settings.reminders.jumua.switch-label", fallback: "Remind about dua in Jumua")
      }
      internal enum MorningEvening {
        /// Evening reminder
        internal static let eveningLabel = L10n.tr("Localizable", "settings.reminders.morning-evening.evening-label", fallback: "Evening reminder")
        /// Morning & Evening adhkar
        internal static let label = L10n.tr("Localizable", "settings.reminders.morning-evening.label", fallback: "Morning & Evening adhkar")
        /// Morning reminder
        internal static let morningLabel = L10n.tr("Localizable", "settings.reminders.morning-evening.morning-label", fallback: "Morning reminder")
        /// Remind about morning & evening adhkar
        internal static let switchLabel = L10n.tr("Localizable", "settings.reminders.morning-evening.switch-label", fallback: "Remind about morning & evening adhkar")
      }
      internal enum NoAccess {
        /// Azkar App can not send notifications since the permission wasn't granted.
        internal static let general = L10n.tr("Localizable", "settings.reminders.no-access.general", fallback: "Azkar App can not send notifications since the permission wasn't granted.")
        /// Azkar App can send notifications but sounds switched off
        internal static let noSound = L10n.tr("Localizable", "settings.reminders.no-access.no-sound", fallback: "Azkar App can send notifications but sounds switched off")
        /// No permission to send notifications
        internal static let titleGeneral = L10n.tr("Localizable", "settings.reminders.no-access.title-general", fallback: "No permission to send notifications")
        /// No access to play sounds
        internal static let titleSound = L10n.tr("Localizable", "settings.reminders.no-access.title-sound", fallback: "No access to play sounds")
        /// Turn ON in Settings
        internal static let turnOnTitle = L10n.tr("Localizable", "settings.reminders.no-access.turn-on-title", fallback: "Turn ON in Settings")
      }
      internal enum Sounds {
        /// Custom
        internal static let custom = L10n.tr("Localizable", "settings.reminders.sounds.custom", fallback: "Custom")
        /// Sound
        internal static let sound = L10n.tr("Localizable", "settings.reminders.sounds.sound", fallback: "Sound")
        /// Standard
        internal static let standard = L10n.tr("Localizable", "settings.reminders.sounds.standard", fallback: "Standard")
        /// Sounds
        internal static let title = L10n.tr("Localizable", "settings.reminders.sounds.title", fallback: "Sounds")
      }
    }
    internal enum Text {
      /// Line spacing (arabic)
      internal static let arabicLineSpacing = L10n.tr("Localizable", "settings.text.arabic-line-spacing", fallback: "Line spacing (arabic)")
      /// Arabic font
      internal static let arabicTextFont = L10n.tr("Localizable", "settings.text.arabic-text-font", fallback: "Arabic font")
      /// Text size
      internal static let fontSize = L10n.tr("Localizable", "settings.text.font-size", fallback: "Text size")
      /// Language
      internal static let language = L10n.tr("Localizable", "settings.text.language", fallback: "Language")
      /// Line spacing
      internal static let lineSpacing = L10n.tr("Localizable", "settings.text.line-spacing", fallback: "Line spacing")
      /// Show tashkeel
      internal static let showTashkeel = L10n.tr("Localizable", "settings.text.show-tashkeel", fallback: "Show tashkeel")
      /// Standard iOS
      internal static let standardFontName = L10n.tr("Localizable", "settings.text.standard-font-name", fallback: "Standard iOS")
      /// Fonts, line spacing, text size
      internal static let subtitle = L10n.tr("Localizable", "settings.text.subtitle", fallback: "Fonts, line spacing, text size")
      /// Text
      internal static let title = L10n.tr("Localizable", "settings.text.title", fallback: "Text")
      /// Line spacing (translation)
      internal static let translationLineSpacing = L10n.tr("Localizable", "settings.text.translation-line-spacing", fallback: "Line spacing (translation)")
      /// Translation font
      internal static let translationTextFont = L10n.tr("Localizable", "settings.text.translation_text_font", fallback: "Translation font")
      /// System text size
      internal static let useSystemFontSize = L10n.tr("Localizable", "settings.text.use-system-font-size", fallback: "System text size")
      /// If this option is turned on Azkar app will use text size from iOS Settings (Settings — Display & Brightness — Text Size).
      /// If it's turned off you can choose desired text size below.
      internal static let useSystemFontSizeTip = L10n.tr("Localizable", "settings.text.use_system_font_size_tip", fallback: "If this option is turned on Azkar app will use text size from iOS Settings (Settings — Display & Brightness — Text Size).\nIf it's turned off you can choose desired text size below.")
    }
    internal enum Theme {
      /// System
      internal static let auto = L10n.tr("Localizable", "settings.theme.auto", fallback: "System")
      /// Color scheme
      internal static let colorScheme = L10n.tr("Localizable", "settings.theme.color-scheme", fallback: "Color scheme")
      /// Dark
      internal static let dark = L10n.tr("Localizable", "settings.theme.dark", fallback: "Dark")
      /// Light
      internal static let light = L10n.tr("Localizable", "settings.theme.light", fallback: "Light")
      /// Themes and app icons
      internal static let subtitle = L10n.tr("Localizable", "settings.theme.subtitle", fallback: "Themes and app icons")
      /// Themes
      internal static let themesTitle = L10n.tr("Localizable", "settings.theme.themes-title", fallback: "Themes")
      /// Appearance
      internal static let title = L10n.tr("Localizable", "settings.theme.title", fallback: "Appearance")
      internal enum ColorTheme {
        /// Color theme
        internal static let header = L10n.tr("Localizable", "settings.theme.color-theme.header", fallback: "Color theme")
        /// Ink
        internal static let ink = L10n.tr("Localizable", "settings.theme.color-theme.ink", fallback: "Ink")
        /// Purple Rose
        internal static let purpleRose = L10n.tr("Localizable", "settings.theme.color-theme.purple-rose", fallback: "Purple Rose")
        /// Rose Quartz
        internal static let roseQuartz = L10n.tr("Localizable", "settings.theme.color-theme.rose-quartz", fallback: "Rose Quartz")
        /// Sea
        internal static let sea = L10n.tr("Localizable", "settings.theme.color-theme.sea", fallback: "Sea")
      }
    }
  }
  internal enum Share {
    /// Image
    internal static let image = L10n.tr("Localizable", "share.image", fallback: "Image")
    /// Include Azkar logo
    internal static let includeAzkarLogo = L10n.tr("Localizable", "share.include-azkar-logo", fallback: "Include Azkar logo")
    /// Include text of benefit
    internal static let includeBenefit = L10n.tr("Localizable", "share.include-benefit", fallback: "Include text of benefit")
    /// Include title
    internal static let includeTitle = L10n.tr("Localizable", "share.include-title", fallback: "Include title")
    /// Share as
    internal static let shareAs = L10n.tr("Localizable", "share.share-as", fallback: "Share as")
    /// Shared from Azkar App
    internal static let sharedWithAzkar = L10n.tr("Localizable", "share.shared-with-azkar", fallback: "Shared from Azkar App")
    /// Text
    internal static let text = L10n.tr("Localizable", "share.text", fallback: "Text")
    /// Text alignment
    internal static let textAlignment = L10n.tr("Localizable", "share.text-alignment", fallback: "Text alignment")
  }
  internal enum Subscribe {
    /// Cancel subscription
    internal static let cancel = L10n.tr("Localizable", "subscribe.cancel", fallback: "Cancel subscription")
    /// Purchase for %@
    internal static func purchaseFor(_ p1: Any) -> String {
      return L10n.tr("Localizable", "subscribe.purchase-for", String(describing: p1), fallback: "Purchase for %@")
    }
    /// Continue
    internal static let purchaseTitle = L10n.tr("Localizable", "subscribe.purchase-title", fallback: "Continue")
    /// Restore
    internal static let restore = L10n.tr("Localizable", "subscribe.restore", fallback: "Restore")
    /// Subscribe
    internal static let subscribeTitle = L10n.tr("Localizable", "subscribe.subscribe-title", fallback: "Subscribe")
    /// Some of the features only available for **Azkar Pro** users.
    internal static let title = L10n.tr("Localizable", "subscribe.title", fallback: "Some of the features only available for **Azkar Pro** users.")
    internal enum Billing {
      /// The subscription renews automatically until you turn it off
      internal static let autoRenewing = L10n.tr("Localizable", "subscribe.billing.auto-renewing", fallback: "The subscription renews automatically until you turn it off")
      /// One-time purchase
      internal static let lifetime = L10n.tr("Localizable", "subscribe.billing.lifetime", fallback: "One-time purchase")
      /// Billed monthly
      internal static let monthly = L10n.tr("Localizable", "subscribe.billing.monthly", fallback: "Billed monthly")
    }
    internal enum Features {
      internal enum ColorThemes {
        /// Colorful themes
        internal static let title = L10n.tr("Localizable", "subscribe.features.color-themes.title", fallback: "Colorful themes")
      }
      internal enum CustomFonts {
        /// 10+ custom fonts
        internal static let title = L10n.tr("Localizable", "subscribe.features.custom-fonts.title", fallback: "10+ custom fonts")
      }
      internal enum More {
        /// And all the new features to come!
        internal static let title = L10n.tr("Localizable", "subscribe.features.more.title", fallback: "And all the new features to come!")
      }
      internal enum ReminderSounds {
        /// Different reminder sounds
        internal static let title = L10n.tr("Localizable", "subscribe.features.reminder-sounds.title", fallback: "Different reminder sounds")
      }
    }
    internal enum Finish {
      /// Thank you for purchasing **Azkar Pro**!
      internal static let thanks = L10n.tr("Localizable", "subscribe.finish.thanks", fallback: "Thank you for purchasing **Azkar Pro**!")
    }
    internal enum Why {
      /// • All basic features of Azkar app available for **free**.
      /// 
      /// • Developing and publishing apps on the App Store takes money and time. Purchases help to cover these costs.
      /// 
      /// • Free apps without ads and purchases do not profit developers.
      /// 
      /// • We decided to provide Pro features instead of adding ads while keeping all the core functionality free.
      internal static let message = L10n.tr("Localizable", "subscribe.why.message", fallback: "• All basic features of Azkar app available for **free**.\n\n• Developing and publishing apps on the App Store takes money and time. Purchases help to cover these costs.\n\n• Free apps without ads and purchases do not profit developers.\n\n• We decided to provide Pro features instead of adding ads while keeping all the core functionality free.")
      /// Why?
      internal static let title = L10n.tr("Localizable", "subscribe.why.title", fallback: "Why?")
    }
  }
  internal enum Subscription {
    internal enum Period {
      /// month
      internal static let month = L10n.tr("Localizable", "subscription.period.month", fallback: "month")
      /// week
      internal static let week = L10n.tr("Localizable", "subscription.period.week", fallback: "week")
      /// year
      internal static let year = L10n.tr("Localizable", "subscription.period.year", fallback: "year")
    }
  }
  internal enum Text {
    internal enum Source {
      /// Abu Daud
      internal static let abudaud = L10n.tr("Localizable", "text.source.abudaud", fallback: "Abu Daud")
      /// Ahmad
      internal static let ahmad = L10n.tr("Localizable", "text.source.ahmad", fallback: "Ahmad")
      /// Beyhaqi
      internal static let beyhaqi = L10n.tr("Localizable", "text.source.beyhaqi", fallback: "Beyhaqi")
      /// al-Bukhari
      internal static let bukhari = L10n.tr("Localizable", "text.source.bukhari", fallback: "al-Bukhari")
      /// ad-Darimi
      internal static let darimi = L10n.tr("Localizable", "text.source.darimi", fallback: "ad-Darimi")
      /// Ibn Huzeyma
      internal static let ibnhuzeyma = L10n.tr("Localizable", "text.source.ibnhuzeyma", fallback: "Ibn Huzeyma")
      /// Muslim
      internal static let muslim = L10n.tr("Localizable", "text.source.muslim", fallback: "Muslim")
      /// an-Nasai
      internal static let nasai = L10n.tr("Localizable", "text.source.nasai", fallback: "an-Nasai")
      /// Quran
      internal static let quran = L10n.tr("Localizable", "text.source.quran", fallback: "Quran")
      /// at-Tirmidhi
      internal static let tirmidhi = L10n.tr("Localizable", "text.source.tirmidhi", fallback: "at-Tirmidhi")
    }
  }
  internal enum Updates {
    /// What's new?
    internal static let title = L10n.tr("Localizable", "updates.title", fallback: "What's new?")
  }
  internal enum Widgets {
    internal enum Virtues {
      /// Different Ayas and ahadith describing virtues of remembering Allah Almighty
      internal static let description = L10n.tr("Localizable", "widgets.virtues.description", fallback: "Different Ayas and ahadith describing virtues of remembering Allah Almighty")
      /// Virtues of dhikr
      internal static let title = L10n.tr("Localizable", "widgets.virtues.title", fallback: "Virtues of dhikr")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
