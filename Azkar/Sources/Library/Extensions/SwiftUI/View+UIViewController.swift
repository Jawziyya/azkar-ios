// Copyright © 2021 Al Jawziyya. All rights reserved. 

import UIKit
import SwiftUI

extension View {

    var wrapped: UIHostingController<Self> {
        UIHostingController(rootView: self)
    }

}
