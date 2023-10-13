// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

public struct DemoFontsService: FontsServiceType {
    
    public init() {}
    
    public func loadFonts<T>(of type: FontsType) async throws -> [T] where T : AppFont, T : Decodable {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                continuation.resume(returning: [])
            }
        }
    }
    
    public func loadFont(url: URL) async throws -> [URL] {
        return []
    }
    
}
