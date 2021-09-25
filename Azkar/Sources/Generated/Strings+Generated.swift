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
    /// Перевод, транскрипция, аудиофайлы озвучки (azkar.ru)
    internal static let azkarRU = L10n.tr("Localizable", "about.azkarRU")
    /// Исходный код приложения Azkar (github.com)
    internal static let sourceCode = L10n.tr("Localizable", "about.sourceCode")
    /// О приложении
    internal static let title = L10n.tr("Localizable", "about.title")
    internal enum Credits {
      /// Анимация %@
      internal static func animation(_ p1: Any) -> String {
        return L10n.tr("Localizable", "about.credits.animation", String(describing: p1))
      }
      /// Шрифт %@
      internal static func font(_ p1: Any) -> String {
        return L10n.tr("Localizable", "about.credits.font", String(describing: p1))
      }
      /// 🎨 Графические материалы и шрифты
      internal static let graphicsHeader = L10n.tr("Localizable", "about.credits.graphics-header")
      /// Изображение %@
      internal static func image(_ p1: Any) -> String {
        return L10n.tr("Localizable", "about.credits.image", String(describing: p1))
      }
      /// 🛠 Библиотеки с открытым кодом
      internal static let openSourceLibrariesHeader = L10n.tr("Localizable", "about.credits.open-source-libraries-header")
      /// Шрифт Комплекса имени Короля Фахда по изданию Священного Корана
      internal static let quranComplexFont = L10n.tr("Localizable", "about.credits.quran-complex-font")
      /// 🗃 Материалы
      internal static let sourcesHeader = L10n.tr("Localizable", "about.credits.sources-header")
    }
    internal enum Studio {
      /// 🥜 Студия Jawziyya
      internal static let header = L10n.tr("Localizable", "about.studio.header")
      /// Страница в Instagram
      internal static let instagramPage = L10n.tr("Localizable", "about.studio.instagram-page")
      /// Наши приложения
      internal static let jawziyyaApps = L10n.tr("Localizable", "about.studio.jawziyya-apps")
      /// Канал в Telegram
      internal static let telegramChannel = L10n.tr("Localizable", "about.studio.telegram-channel")
    }
    internal enum Support {
      /// ⚒ Обратная связь
      internal static let header = L10n.tr("Localizable", "about.support.header")
      /// Оставить отзыв
      internal static let leaveReview = L10n.tr("Localizable", "about.support.leave-review")
      /// Написать на эл. почту
      internal static let writeToEmail = L10n.tr("Localizable", "about.support.write-to-email")
    }
  }

  internal enum Alerts {
    /// Выберите значок для приложения Azkar
    internal static let checkoutIconPacks = L10n.tr("Localizable", "alerts.checkout-icon-packs")
    /// Включите уведомления, чтобы приложение напоминало о времени утренних и вечерних азкаров
    internal static let turnOnNotificationsAlert = L10n.tr("Localizable", "alerts.turn-on-notifications-alert")
  }

  internal enum Category {
    /// Азкары после молитвы
    internal static let afterSalah = L10n.tr("Localizable", "category.after-salah")
    /// Вечерние
    internal static let evening = L10n.tr("Localizable", "category.evening")
    /// Утренние
    internal static let morning = L10n.tr("Localizable", "category.morning")
    /// Важные азкары
    internal static let other = L10n.tr("Localizable", "category.other")
  }

  internal enum Common {
    /// Восстановить
    internal static let restore = L10n.tr("Localizable", "common.restore")
    /// Поделиться приложением
    internal static let shareApp = L10n.tr("Localizable", "common.share-app")
    /// Версия
    internal static let version = L10n.tr("Localizable", "common.version")
    /// Зикр
    internal static let zikr = L10n.tr("Localizable", "common.zikr")
  }

  internal enum IconPack {
    internal enum Darsigova {
      /// Закаты и рассветы как хранители нашей веры, в которых заложена милость от Господа.
      internal static let description = L10n.tr("Localizable", "icon_pack.darsigova.description")
      /// Набор значков «Хранители веры»
      internal static let title = L10n.tr("Localizable", "icon_pack.darsigova.title")
    }
    internal enum Info {
      /// Вы приобрели этот набор 🎉
      internal static let purchasedMessage = L10n.tr("Localizable", "icon_pack.info.purchased-message")
    }
    internal enum Maccinz {
      /// Мягкие тона, атмосфера домашнего уюта и спокойствия.
      internal static let description = L10n.tr("Localizable", "icon_pack.maccinz.description")
      /// Набор значков «Иллюстрации»
      internal static let title = L10n.tr("Localizable", "icon_pack.maccinz.title")
    }
    internal enum Standard {
      /// 
      internal static let description = L10n.tr("Localizable", "icon_pack.standard.description")
      /// Стандартный набор значков
      internal static let title = L10n.tr("Localizable", "icon_pack.standard.title")
    }
  }

  internal enum Notifications {
    /// Вечерние азкары 🌄
    internal static let eveningNotificationTitle = L10n.tr("Localizable", "notifications.evening-notification-title")
    /// Утренние азкары 🌅
    internal static let morningNotificationTitle = L10n.tr("Localizable", "notifications.morning-notification-title")
  }

  internal enum Read {
    /// привёл
    internal static let narratedBy = L10n.tr("Localizable", "read.narrated-by")
    /// повторения
    internal static let repeats = L10n.tr("Localizable", "read.repeats")
    /// источник
    internal static let source = L10n.tr("Localizable", "read.source")
    /// транскрипция
    internal static let transcription = L10n.tr("Localizable", "read.transcription")
    /// перевод
    internal static let translation = L10n.tr("Localizable", "read.translation")
  }

  internal enum Root {
    /// О приложении
    internal static let about = L10n.tr("Localizable", "root.about")
    /// Выберите раздел
    internal static let pickSection = L10n.tr("Localizable", "root.pick-section")
    /// Настройки
    internal static let settings = L10n.tr("Localizable", "root.settings")
  }

  internal enum Settings {
    /// Украшения
    internal static let funFeatures = L10n.tr("Localizable", "settings.fun_features")
    /// Настройки
    internal static let title = L10n.tr("Localizable", "settings.title")
    internal enum FunFeatures {
      /// Это функции, которые делают приложение более красочным, но по мнению некоторых людей являются лишними, и они были бы рады их отключить.\nТеперь у таких людей есть своя кнопка. :-)
      internal static let description = L10n.tr("Localizable", "settings.fun_features.description")
    }
    internal enum Icon {
      /// Значок
      internal static let title = L10n.tr("Localizable", "settings.icon.title")
      internal enum List {
        /// Тёмная ночь
        internal static let darkNight = L10n.tr("Localizable", "settings.icon.list.dark_night")
        /// Миг
        internal static let darsigova1 = L10n.tr("Localizable", "settings.icon.list.darsigova_1")
        /// В объятьях вечера
        internal static let darsigova10 = L10n.tr("Localizable", "settings.icon.list.darsigova_10")
        /// Связующие нити
        internal static let darsigova2 = L10n.tr("Localizable", "settings.icon.list.darsigova_2")
        /// На краю времени
        internal static let darsigova3 = L10n.tr("Localizable", "settings.icon.list.darsigova_3")
        /// Свобода
        internal static let darsigova4 = L10n.tr("Localizable", "settings.icon.list.darsigova_4")
        /// Свет в городе
        internal static let darsigova5 = L10n.tr("Localizable", "settings.icon.list.darsigova_5")
        /// Воздушное мгновенье
        internal static let darsigova6 = L10n.tr("Localizable", "settings.icon.list.darsigova_6")
        /// Звёзды в небе горят
        internal static let darsigova7 = L10n.tr("Localizable", "settings.icon.list.darsigova_7")
        /// Полёт цвета
        internal static let darsigova8 = L10n.tr("Localizable", "settings.icon.list.darsigova_8")
        /// Нежность
        internal static let darsigova9 = L10n.tr("Localizable", "settings.icon.list.darsigova_9")
        /// Золото
        internal static let gold = L10n.tr("Localizable", "settings.icon.list.gold")
        /// Чернила
        internal static let ink = L10n.tr("Localizable", "settings.icon.list.ink")
        /// Солнечный день
        internal static let maccinzDay = L10n.tr("Localizable", "settings.icon.list.maccinz_day")
        /// Праздничная атмосфера
        internal static let maccinzHouse = L10n.tr("Localizable", "settings.icon.list.maccinz_house")
        /// Высоко в горах
        internal static let maccinzMountains = L10n.tr("Localizable", "settings.icon.list.maccinz_mountains")
        /// Ночь в рамадан
        internal static let maccinzRamadanNight = L10n.tr("Localizable", "settings.icon.list.maccinz_ramadan_night")
        /// Рамадан
        internal static let ramadan = L10n.tr("Localizable", "settings.icon.list.ramadan")
      }
    }
    internal enum Notifications {
      /// Напоминание о вечерних азкарах
      internal static let eveningOptionLabel = L10n.tr("Localizable", "settings.notifications.evening-option-label")
      /// Напоминание об утренних азкарах
      internal static let morningOptionLabel = L10n.tr("Localizable", "settings.notifications.morning-option-label")
      /// Напоминать об утренних и вечерних азкарах
      internal static let switchLabel = L10n.tr("Localizable", "settings.notifications.switch-label")
      /// Уведомления
      internal static let title = L10n.tr("Localizable", "settings.notifications.title")
    }
    internal enum Text {
      /// Шрифт арабского текста
      internal static let arabicTextFont = L10n.tr("Localizable", "settings.text.arabic-text-font")
      /// Размер текста
      internal static let fontSize = L10n.tr("Localizable", "settings.text.font-size")
      /// Отображать огласовки
      internal static let showTashkeel = L10n.tr("Localizable", "settings.text.show-tashkeel")
      /// Стандартный iOS
      internal static let standardFontName = L10n.tr("Localizable", "settings.text.standard-font-name")
      /// Текст
      internal static let title = L10n.tr("Localizable", "settings.text.title")
      /// Системный размер текста
      internal static let useSystemFontSize = L10n.tr("Localizable", "settings.text.use-system-font-size")
    }
    internal enum Theme {
      /// Авто
      internal static let auto = L10n.tr("Localizable", "settings.theme.auto")
      /// Тёмная
      internal static let dark = L10n.tr("Localizable", "settings.theme.dark")
      /// Светлая
      internal static let light = L10n.tr("Localizable", "settings.theme.light")
      /// Тема
      internal static let title = L10n.tr("Localizable", "settings.theme.title")
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
