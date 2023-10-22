// Copyright © 2023 Azkar
// All Rights Reserved.

import Coordinator

extension Coordinator {
    func dismissModal() {
        (rootViewController.presentedViewController ?? rootViewController).dismiss(animated: true)
    }
}
