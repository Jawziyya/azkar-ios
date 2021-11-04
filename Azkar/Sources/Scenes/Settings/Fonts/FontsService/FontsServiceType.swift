// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

protocol FontsServiceType {
    func loadFonts() async throws -> [AppFont]
    func loadFont(url: URL) async throws -> [URL]
}
