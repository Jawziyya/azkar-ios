// Copyright © 2021 Al Jawziyya. All rights reserved. 

import UIKit
import SwiftUI
import MessageUI

final class ZikrPagesViewController: UIHostingController<ZikrPagesView> {
    
    private let viewModel: ZikrPagesViewModel
    private var shareMenuItem: UIBarButtonItem?
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

        let shareBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "square.and.arrow.up"),
            primaryAction: nil,
            menu: UIMenu(
                title: L10n.Common.share,
                children: [
                    UIAction(title: L10n.Share.image, image: UIImage(systemName: "photo"), handler: { _ in
                        self.share(shareAsImage: true)
                    }),
                    UIAction(title: L10n.Share.text, image: UIImage(systemName: "doc.plaintext"), handler: { _ in
                        self.share()
                    })
                ])
        )
        self.shareMenuItem = shareBarButtonItem
        navigationItem.rightBarButtonItems = [shareBarButtonItem, settingsMenuItem]
        updateStyle()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateStyle()
    }
    
    private func updateStyle() {
        shareMenuItem?.tintColor = UIColor(Color.accent)
        settingsMenuItem.tintColor = UIColor(Color.accent)
    }
    
    @objc private func share(shareAsImage: Bool = false) {
        let currentViewModel = viewModel.azkar[viewModel.page]
        let activityItems: [Any]

        if shareAsImage {
            let view = ZikrShareView(
                viewModel: currentViewModel,
                includeTranslation: viewModel.preferences.expandTranslation,
                includeTransliteration: viewModel.preferences.expandTransliteration
            )
            .frame(width: view.bounds.width)
            .frame(maxHeight: .infinity)
            let image = view.snapshot()
            let tempDir = FileManager.default.temporaryDirectory
            let imgFileName = "\(currentViewModel.title).png"
            let tempImagePath = tempDir.appendingPathComponent(imgFileName)
            try? image.pngData()?.write(to: tempImagePath)
            activityItems = [tempImagePath]
        } else {
            let text = currentViewModel.getShareText(
                includeTitle: true,
                includeTranslation: viewModel.preferences.expandTranslation,
                includeTransliteration: viewModel.preferences.expandTransliteration,
                includeBenefit: true
            )
            activityItems = [text]
        }

        let activityController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: [ZikrFeedbackActivity(prepareAction: { [unowned self] in
                self.presentMailComposer()
            })]
        )
        activityController.excludedActivityTypes = [
            .init(rawValue: "com.apple.reminders.sharingextension")
        ]
        if let popover = activityController.popoverPresentationController {
            popover.barButtonItem = self.shareMenuItem
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
