//
//  TextLabel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import Combine

struct TextLabel: UIViewRepresentable {

    public final class Coordinator: NSObject {
        private let parent: TextLabel

        public init(_ parent: TextLabel) {
            self.parent = parent
        }
    }

    @Binding var height: CGFloat
    let containerWidth: CGFloat
    var attributedString: (() -> NSAttributedString)

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.autoresizesSubviews = true
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }

    func updateUIView(_ label: UILabel, context: Context) {
        let string = self.attributedString()
        DispatchQueue.main.async {
            label.attributedText = string
            label.sizeToFit()
            let size = label.systemLayoutSizeFitting(CGSize(width: containerWidth, height: CGFloat.greatestFiniteMagnitude))
            self.height = max(30, size.height.rounded(.up))
        }
    }

}
