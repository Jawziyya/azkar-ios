// Copyright © 2021 Al Jawziyya. All rights reserved. 

import UIKit
import SwiftUI
import MessageUI

private let INSTAGRAM_STORIES_URL = URL(string: "instagram-stories://share")!

final class ZikrPagesViewController: UIHostingController<ZikrPagesView> {

    enum ShareType {
        case image, text, instagramStory
    }
    
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

        var menuItems: [UIMenuElement] = [
            UIMenu(title: "", options: .displayInline, children: [
                UIAction(title: L10n.Share.image, image: UIImage(systemName: "photo"), handler: { _ in
                    self.share(type: .image)
                }),
                UIAction(title: L10n.Share.text, image: UIImage(systemName: "doc.plaintext"), handler: { _ in
                    self.share(type: .text)
                }),
            ])
        ]

        if UIApplication.shared.canOpenURL(INSTAGRAM_STORIES_URL) {
            menuItems.append(
                UIMenu(title: "", options: .displayInline, children: [
                    UIAction(title: "Instagram", image: UIImage(systemName: "circle.fill.square.fill"), handler: { _ in
                        self.share(type: .instagramStory)
                    })
                ])
            )
        }

        let shareBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "square.and.arrow.up"),
            primaryAction: nil,
            menu: UIMenu(title: L10n.Common.share ,children: menuItems)
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
    
    private func share(type: ShareType) {
        let currentViewModel = viewModel.azkar[viewModel.page]
        let activityItems: [Any]

        switch type {

        case .image, .instagramStory:

            let view = ZikrShareView(
                viewModel: currentViewModel,
                includeTranslation: viewModel.preferences.expandTranslation,
                includeTransliteration: viewModel.preferences.expandTransliteration,
                arabicTextAlignment: .center,
                otherTextAlignment: .center
            )
            .frame(width: view.bounds.width)
            .frame(maxHeight: .infinity)
            let image = view.snapshot()

            if type == .image {
                let tempDir = FileManager.default.temporaryDirectory
                let imgFileName = "\(currentViewModel.title).png"
                let tempImagePath = tempDir.appendingPathComponent(imgFileName)
                try? image.pngData()?.write(to: tempImagePath)
                activityItems = [tempImagePath]
            } else if type == .instagramStory {
                guard let data = image.pngData() else {
                    return
                }
                let isDarkModeEnabled = self.traitCollection.userInterfaceStyle == .dark
                let bgColor = isDarkModeEnabled ? "#111111" : "#F7F7F7"
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": data,
                    "com.instagram.sharedSticker.backgroundTopColor": bgColor,
                    "com.instagram.sharedSticker.backgroundBottomColor": bgColor
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(INSTAGRAM_STORIES_URL, options: [:], completionHandler: nil)
                return
            } else {
                return
            }

        case .text:
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
