// Copyright © 2021 Al Jawziyya. All rights reserved. 

import UIKit
import SwiftUI
import MessageUI

let INSTAGRAM_STORIES_URL = URL(string: "instagram-stories://share")!

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

        func getAction(for type: ShareType) -> UIMenuElement {
            UIAction(title: type.title, image: UIImage(systemName: type.imageName), handler: { _ in
                self.share(options: .init(shareType: type))
            })
        }

        var menuItems: [UIMenuElement] = [
            UIMenu(title: "", options: .displayInline, children: [
                getAction(for: .image),
                getAction(for: .text),
            ])
        ]

        if UIApplication.shared.canOpenURL(INSTAGRAM_STORIES_URL) {
            menuItems.append(
                UIMenu(title: "", options: .displayInline, children: [
                    getAction(for: .instagramStories)
                ])
            )
        }

        let shareBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(presentShareOptions(_:))
        )

        shareBarButtonItem.menu = UIMenu(title: L10n.Common.share ,children: menuItems)

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

    @objc private func presentShareOptions(_ sender: UIBarButtonItem) {
        let view = NavigationView {
            ZikrShareOptionsView { [unowned self] options in
                self.share(options: options)
            }
            .accentColor(Color.accent)
        }
        let viewController = UIHostingController(rootView: view)
        present(viewController, animated: true)
    }
    
    private func share(options: ZikrShareOptionsView.ShareOptions) {
        let currentViewModel = viewModel.azkar[viewModel.page]
        let activityItems: [Any]

        switch options.shareType {

        case .image, .instagramStories:

            let view = ZikrShareView(
                viewModel: currentViewModel,
                includeTitle: options.includeTitle,
                includeTranslation: viewModel.preferences.expandTranslation,
                includeTransliteration: viewModel.preferences.expandTransliteration,
                includeBenefits: options.includeBenefits,
                includeLogo: options.includeLogo,
                arabicTextAlignment: options.textAlignment.isCentered ? .center : .trailing,
                otherTextAlignment: options.textAlignment.isCentered ? .center : .leading
            )
            .frame(width: view.bounds.width)
            .frame(maxHeight: .infinity)
            let image = view.snapshot()

            if options.shareType == .image {
                let tempDir = FileManager.default.temporaryDirectory
                let imgFileName = "\(currentViewModel.title).png"
                let tempImagePath = tempDir.appendingPathComponent(imgFileName)
                try? image.pngData()?.write(to: tempImagePath)
                activityItems = [tempImagePath]
            } else if options.shareType == .instagramStories {
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
                includeTitle: options.includeTitle,
                includeTranslation: viewModel.preferences.expandTranslation,
                includeTransliteration: viewModel.preferences.expandTransliteration,
                includeBenefits: options.includeBenefits
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
