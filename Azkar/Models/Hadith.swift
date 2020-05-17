//
//  Hadith.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 16.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation

struct Hadith: Codable, Identifiable {
    let id: Int
    let number: String
    let text: String
    let translation: String?
    let source: String

    static var data: [Hadith] = {
        let url = Bundle.main.url(forResource: "ahadith", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let azkar = try! decoder.decode([Hadith].self, from: data)
        return azkar
    }()
}
