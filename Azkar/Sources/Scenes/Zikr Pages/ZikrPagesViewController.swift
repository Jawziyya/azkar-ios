// Copyright © 2021 Al Jawziyya. All rights reserved. 

import UIKit
import SwiftUI
import MessageUI

final class ZikrPagesViewController: UIHostingController<ZikrPagesView> {
    
    private let viewModel: ZikrPagesViewModel
    private lazy var shareMenuItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(share))
    private lazy var settingsMenuItem = UIBarButtonItem(image: UIImage(systemName: "textformat"), style: .plain, target: self, action: #selector(goToSettings))
    
    init(viewModel: ZikrPagesViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ZikrPagesView(viewModel: viewModel))
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStyle()
        navigationItem.rightBarButtonItems = [shareMenuItem, settingsMenuItem]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateStyle()
    }
    
    private func updateStyle() {
        shareMenuItem.tintColor = UIColor(Color.accent)
        settingsMenuItem.tintColor = UIColor(Color.accent)
    }
    
    @objc private func share(_ sender: UIBarButtonItem) {
        let currentViewModel = viewModel.azkar[viewModel.page]
        let activityController = UIActivityViewController(
            activityItems: [currentViewModel.getShareText()],
            applicationActivities: [ZikrFeedbackActivity(prepareAction: { [unowned self] in
                self.presentMailComposer()
            })]
        )
        activityController.excludedActivityTypes = [
            .init(rawValue: "com.apple.reminders.sharingextension")
        ]
        if let popover = activityController.popoverPresentationController {
            popover.barButtonItem = sender
        }
        present(activityController, animated: true)
    }
    
    @objc private func goToSettings(_ sender: UIBarButtonItem) {
        viewModel.navigateToSettings()
    }
    
    private func presentMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            UIApplication.shared.open(URL(string: "https://t.me/jawziyya_feedback")!)
            return
        }
        let viewController = MFMailComposeViewController()
        viewController.setToRecipients(["azkar.app@pm.me"])
        viewController.mailComposeDelegate = self
        present(viewController, animated: true)
    }
    
}

extension ZikrPagesViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
    
}
