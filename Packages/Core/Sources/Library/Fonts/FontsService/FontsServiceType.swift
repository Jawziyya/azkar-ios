// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

public enum FontsType {
    case arabic, translation
    
    public var url: String {
        switch self {
        case .arabic:
            return "https://azkar.ams3.digitaloceanspaces.com/media/fonts/arabic_fonts.json"
        case .translation:
            return "https://azkar.ams3.digitaloceanspaces.com/media/fonts/translation_fonts.json"
        }
    }
}

public protocol FontsServiceType {
    func loadFonts<T: AppFont & Decodable>(of type: FontsType) async throws -> [T]
    func loadFont(url: URL) async throws -> [URL]
}
