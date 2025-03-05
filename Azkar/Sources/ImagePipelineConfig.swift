// Copyright © 2022 Al Jawziyya. All rights reserved.

import Foundation
import Nuke

extension ImagePipeline {
    static let shared: ImagePipeline = {
        // Create a custom configuration
        var configuration = ImagePipeline.Configuration()
        
        // Configure memory cache (1/4 of available RAM)
        configuration.imageCache = ImageCache(costLimit: 1024 * 1024 * 250)
        
        // Enable progressive decoding for better user experience
        configuration.isProgressiveDecodingEnabled = true
        
        // Enable image decompression
        configuration.isDecompressionEnabled = true

        // Configure disk cache
        configuration.dataCache = try? DataCache(name: "com.aljawziyya.azkar.imagecache")
        configuration.dataCachePolicy = .automatic
        
        // Return a pipeline with this configuration
        return ImagePipeline(configuration: configuration)
    }()
}
