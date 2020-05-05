//
//  Label.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import Combine

extension NSAttributedString {

    func height(withMaxWidth maxWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let height = boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
        return height
    }

}

struct Label: UIViewRepresentable {

    public final class Coordinator: NSObject {
        private let parent: Label

        public init(_ parent: Label) {
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
            let height = (self.getHeightOfTheText(maxWidth: self.containerWidth, attributedText: string)).rounded(.up)
            self.height = max(30, height)
        }
    }

    private func getHeightOfTheText(maxWidth: CGFloat, attributedText: NSAttributedString) -> CGFloat {
        let height = attributedText.height(withMaxWidth: maxWidth)
        return height
    }

}
