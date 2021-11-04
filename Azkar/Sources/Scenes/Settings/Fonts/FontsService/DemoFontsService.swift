// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

struct DemoFontsService: FontsServiceType {
    
    func loadFont(url: URL) async throws -> [URL] {
        return []
    }
    
    func loadFonts() async -> [AppFont] {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                continuation.resume(returning: [.placeholder, .placeholder, .placeholder])
            }
        }
    }
}
