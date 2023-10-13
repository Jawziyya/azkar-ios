// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI

public struct ExecuteCallView: View {
    public init(_ call: () -> Void) {
        call()
    }

    public var body: some View {
        return EmptyView()
    }
}
