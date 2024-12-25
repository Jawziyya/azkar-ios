// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI

enum ShareType: String, CaseIterable, Identifiable {
    case image, text, instagramStories

    static var availableCases: [ShareType] {
        var cases = [ShareType.image, .text]
        if UIApplication.shared.canOpenURL(Constants.INSTAGRAM_STORIES_URL) {
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
    
    let zikr: Zikr

    struct ShareOptions {
        let includeTitle: Bool
        let includeTranslation: Bool
        let includeTransliteration: Bool
        let includeBenefits: Bool
        let includeLogo: Bool
        var textAlignment: ShareTextAlignment = .start
        let shareType: ShareType
    }

    var callback: (ShareOptions) -> Void

    @Environment(\.presentationMode)
    var presentation
    
    @State private var showExtraOptions = false

    @AppStorage("kShareIncludeTitle")
    private var includeTitle: Bool = true
    
    @State private var includeTranslation = Preferences.shared.expandTranslation
    @State private var includeTransliteration = Preferences.shared.expandTransliteration

    @AppStorage("kShareIncludeBenefits")
    private var includeBenefits = true

    @AppStorage("kShareIncludeLogo")
    private var includeLogo = true

    @AppStorage("kShareShareType")
    private var selectedShareType = ShareType.image

    @AppStorage("kShareTextAlignment")
    private var textAlignment = ShareTextAlignment.start

    private let alignments: [ShareTextAlignment] = [.center, .start]
    
    var body: some View {
        VStack(spacing: 0) {
            toolbar
                .padding()
            
            content
                .listStyle(.insetGrouped)
                .customScrollContentBackground()
        }
        .background(Color.background, ignoresSafeAreaEdges: .all)
    }
    
    var toolbar: some View {
        HStack {
            Button(L10n.Common.done) {
                presentation.dismiss()
            }
            Spacer()
            Button(L10n.Common.share) {
                share()
            }
            .buttonStyle(.borderedProminent)
        }
        .background(Color.background)
    }

    var content: some View {
        List {
            Group {
                shareAsSection
                
                shareOptions
            }
            .listRowBackground(Color.contentBackground)
        }
    }
    
    var shareAsSection: some View {
        Section(header: L10n.Share.shareAs) {
            ForEach(ShareType.availableCases) { type in
                Button(action: {
                    selectedShareType = type
                }, label: {
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
                })
                .buttonStyle(.plain)
            }
        }
    }
    
    var shareOptions: some View {
        VStack {
            Button {
                showExtraOptions.toggle()
            } label: {
                HStack {
                    Text(L10n.Share.extraOptions)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(showExtraOptions ? 90 : 0))
                }
            }
            
            if showExtraOptions {
                extraOptions
            }
        }
    }
    
    var extraOptions: some View {
        Section {
            Toggle(L10n.Share.includeTitle, isOn: $includeTitle)
            Toggle(L10n.Share.includeTranslation, isOn: $includeTranslation)
            Toggle(L10n.Share.includeTransliteration, isOn: $includeTransliteration)
            Toggle(L10n.Share.includeBenefit, isOn: $includeBenefits)
            
            Divider()
            
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
                
                Divider()
                
                Section {
                    Toggle(L10n.Share.includeAzkarLogo, isOn: $includeLogo)
                }
            }
        }
        .pickerStyle(.segmented)
    }

    @MainActor
    private func share() {
        callback(ShareOptions(
            includeTitle: includeTitle,
            includeTranslation: includeTranslation,
            includeTransliteration: includeTransliteration,
            includeBenefits: includeBenefits,
            includeLogo: includeLogo,
            textAlignment: textAlignment,
            shareType: selectedShareType)
        )
    }

}

#Preview("Share Options") {
    ZikrShareOptionsView(zikr: .placeholder(), callback: { _ in })
        .tint(Color.accentColor)
}
