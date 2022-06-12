// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI

struct ExecuteCallView: View {
    init(_ call: () -> Void) {
        call()
    }

    var body: some View {
        return EmptyView()
    }
}
