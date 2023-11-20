// Copyright © 2021 Al Jawziyya. All rights reserved. 

import UIKit
import SwiftUI
import MessageUI
import Library
import IGStoryKit

final class ZikrPagesViewController: UIHostingController<ZikrPagesView> {

    private let viewModel: ZikrPagesViewModel
    
    init(viewModel: ZikrPagesViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ZikrPagesView(viewModel: viewModel))
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ZikrPagesViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
    
}
