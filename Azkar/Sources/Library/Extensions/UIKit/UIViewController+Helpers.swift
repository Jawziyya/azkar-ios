// Copyright © 2021 Al Jawziyya. All rights reserved. 

import UIKit

extension UIViewController {

    var isPadInterface: Bool {
        traitCollection.userInterfaceIdiom == .pad || traitCollection.userInterfaceIdiom == .mac
    }

    func replaceDetailViewController(with viewController: UIViewController) {
        if traitCollection.userInterfaceIdiom == .phone {
            showDetailViewController(viewController, sender: self)
        } else {
            splitViewController?.setViewController(nil, for: .secondary)
            splitViewController?.setViewController(viewController, for: .secondary)
        }
    }

}
