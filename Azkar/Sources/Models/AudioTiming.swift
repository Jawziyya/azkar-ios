// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation

struct AudioTiming: Hashable, Codable {
    enum CodingKeys: String, CodingKey {
        case audioId = "audio_id"
        case time
    }

    let audioId: Int
    let time: Double
}
