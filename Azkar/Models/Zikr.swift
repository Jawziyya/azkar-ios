//
//  Zikr.swift
//  Azkar
//
//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation
import AVFoundation

enum ZikrCategory: String, Codable {
    case morning, evening, afterSalah = "after-salah", other

    var title: String {
        return NSLocalizedString("category." + rawValue, comment: "")
    }
}

struct Zikr: Identifiable, Hashable, Equatable, Codable {
    
    let id: Int
    let hadith: Int?
    let rowInCategory: Int
    let title: String?
    let text: String
    let translation: String
    let transliteration: String
    let notes: String?
    let category: ZikrCategory

    var audioURL: URL? {
        return Bundle.main.url(forResource: "\(category.rawValue)\(rowInCategory)", withExtension: "mp3")
    }
    
    let repeats: Int
    let source: String

    var audioDuration: Double? {
        guard let url = audioURL else {
            return nil
        }
        let asset = AVURLAsset(url: url)
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
    static var data: [Zikr] = {
        let url = Bundle.main.url(forResource: "azkar", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let azkar = try! JSONDecoder().decode([Zikr].self, from: data)
        return azkar
    }()
    
}
