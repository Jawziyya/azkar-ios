// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation

public struct AudioTiming: Hashable, Codable {
    enum CodingKeys: String, CodingKey {
        case audioId = "audio_id"
        case time
    }

    public let audioId: Int
    public let time: Double
}
