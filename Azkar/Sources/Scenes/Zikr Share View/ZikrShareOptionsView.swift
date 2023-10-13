// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI

enum ShareType: String, CaseIterable, Identifiable {
    case image, text, instagramStories

    static var availableCases: [ShareType] {
        var cases = [ShareType.image, .text]
        if UIApplication.shared.canOpenURL(INSTAGRAM_STORIES_URL) {
            cases.append(.instagramStories)
        }
        return cases
    }

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .text:
            return L10n.Share.text
        case .image:
            return L10n.Share.image
        case .instagramStories:
            return "Instagram Stories"
        }
    }

    var imageName: String {
        switch self {
        case .image:
            return "photo"
        case .text:
            return "doc.plaintext"
        case .instagramStories:
            return "circle.fill.square.fill"
        }
    }
}

enum ShareTextAlignment: String, Identifiable, CaseIterable {
    case start, center

    public var id: String {
        imageName
    }

    var imageName: String {
        switch self {
        case .start:
            return "text.alignright"
        case .center:
            return "text.aligncenter"
        }
    }

    var isCentered: Bool {
        self == .center
    }
}

struct ZikrShareOptionsView: View {

    struct ShareOptions {
        var includeTitle = UserDefaults.standard.bool(forKey: "kShareIncludeTitle")
        var includeBenefits = UserDefaults.standard.bool(forKey: "kShareIncludeBenefits")
        var includeLogo = UserDefaults.standard.bool(forKey: "kShareIncludeLogo")
        var textAlignment: ShareTextAlignment = .center
        var shareType: ShareType = .instagramStories
    }

    var callback: (ShareOptions) -> Void

    @Environment(\.presentationMode)
    var presentation

    @AppStorage("kShareIncludeTitle")
    private var includeTitle: Bool = true

    @AppStorage("kShareIncludeBenefits")
    private var includeBenefits = true

    @AppStorage("kShareIncludeLogo")
    private var includeLogo = true

    @AppStorage("kShareShareType")
    private var selectedShareType = ShareType.image

    @AppStorage("kShareTextAlignment")
    private var textAlignment = ShareTextAlignment.center

    private let alignments: [ShareTextAlignment] = [.center, .start]

    var body: some View {
        Form {
            Section {
                ForEach(ShareType.availableCases) { type in
                    Button(
                        action: {
                            selectedShareType = type
                        },
                        label: {
                            HStack {
                                Text(type.title)
                                Spacer()
                                if type == selectedShareType {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(Color.accent)
                                }
                            }
                            .contentShape(Rectangle())
                        }
                    )
                    .buttonStyle(.plain)
                }
            }

            Section {
                Toggle(L10n.Share.includeTitle, isOn: $includeTitle)
                Toggle(L10n.Share.includeBenefit, isOn: $includeBenefits)

                if selectedShareType != .text {
                    HStack(spacing: 16) {
                        Text(L10n.Share.textAlignment)
                        Spacer()
                        Picker(L10n.Share.textAlignment, selection: $textAlignment) {
                            ForEach(alignments) { alignment in
                                Image(systemName: alignment.imageName)
                                    .tag(alignment)
                            }
                        }
                    }
                }
            }
            .pickerStyle(.segmented)

            if selectedShareType != .text {
                Section {
                    Toggle(L10n.Share.includeAzkarLogo, isOn: $includeLogo)
                }
            }
        }
        .navigationBarTitle(L10n.Common.share)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: share) {
                    Text(L10n.Common.send)
                }
            }
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }

    private func share() {
        presentation.wrappedValue.dismiss()
        callback(ShareOptions(
            includeTitle: includeTitle,
            includeBenefits: includeBenefits,
            includeLogo: includeLogo,
            textAlignment: textAlignment,
            shareType: selectedShareType)
        )
    }

}

struct ZikrShareOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZikrShareOptionsView(callback: { _ in })
        }
        .environment(\.colorScheme, .dark)
    }
}
