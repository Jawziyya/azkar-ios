// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI
import UIKit

extension UIViewController {
    func snapshot(size: CGSize? = nil) -> UIImage {
        let targetSize = size ?? self.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension View {
    func snapshot(size: CGSize? = nil) -> UIImage {
        let controller = UIHostingController(rootView: self)
        return controller.snapshot(size: size)
    }
}
