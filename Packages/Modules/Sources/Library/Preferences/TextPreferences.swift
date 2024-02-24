// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation

public protocol TextProcessingPreferences {
    var showTashkeel: Bool { get }
    var preferredArabicFont: ArabicFont { get }
    var enableLineBreaks: Bool { get }
}
