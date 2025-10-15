import Foundation

public class MockShareBackgroundsService: ShareBackgroundService {
    public override init() {}

    public override func loadBackgrounds() async throws -> [ZikrShareBackgroundItem] {
        return []
    }
}

