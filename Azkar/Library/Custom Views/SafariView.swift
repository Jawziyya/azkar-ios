//
//  Safari.swift
//  LetSwift
//
//  Created by BumMo Koo on 2019/11/08.
//  Copyright © 2019 Cleanios. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    var entersReaderIfAvailable = false
    var preferredTintColor: UIColor?

    // MARK: - Representable
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = entersReaderIfAvailable
        let safari = SFSafariViewController(url: url, configuration: configuration)
        safari.preferredControlTintColor = preferredTintColor
        return safari
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}

// MARK: - Preview
struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://google.com/")!
        return SafariView(url: url, entersReaderIfAvailable: false)
    }
}
