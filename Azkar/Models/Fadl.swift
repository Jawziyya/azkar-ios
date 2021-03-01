//
//
//  Azkar
//  
//  Created on 22.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import Foundation

struct Fadl: Codable, Identifiable {
    let id: Int
    let text: String
    let source: String

    static var all: [Fadl] = {
        let url = Bundle.main.url(forResource: "fudul", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try! decoder.decode([Fadl].self, from: data)
    }()
}
