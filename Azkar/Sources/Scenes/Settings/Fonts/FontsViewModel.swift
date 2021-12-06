// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI

struct AppFontViewModel: Identifiable, Equatable {
    
    private static let baseURL = URL(string: "https://azkar.ams3.digitaloceanspaces.com/media/fonts/files")!
    
    let id = UUID()
    let font: AppFont
    let name: String
    let imageURL: URL?
    let zipFileURL: URL?
    
    init(font: AppFont) {
        self.font = font
        name = font.name
        let langId: String
        switch languageIdentifier {
        case .ar: langId = "en"
        default: langId = languageIdentifier.rawValue
        }
        
        let referenceName = font.referenceName
        if referenceName != AppFont.defaultFontName {
            imageURL = AppFontViewModel.baseURL.appendingPathComponent("\(referenceName)/\(referenceName)_\(langId).png")
            zipFileURL = AppFontViewModel.baseURL.appendingPathComponent(referenceName).appendingPathComponent("\(referenceName).zip")
        } else {
            imageURL = nil
            zipFileURL = nil
        }
    }
}

final class FontsViewModel: ObservableObject {
    
    @Published var didLoadData = false
    @Published var fonts: [FontsSection] = [
        FontsSection(type: .appFont(.serif), fonts: [.placeholder, .placeholder, .placeholder].map(AppFontViewModel.init)),
        FontsSection(type: .appFont(.sansSerif), fonts: [.placeholder, .placeholder].map(AppFontViewModel.init)),
        FontsSection(type: .appFont(.handwritten), fonts: [.placeholder, .placeholder, .placeholder].map(AppFontViewModel.init)),
        FontsSection(type: .appFont(.decorative), fonts: [.placeholder].map(AppFontViewModel.init)),
    ]
    @Published var preferredFont: AppFont
    @Published var loadingFonts = Set<AppFont>()
    
    struct FontsSection: Equatable, Identifiable {
        
        enum FontsSectionType: Equatable {
            case stantard
            case appFont(AppFont.FontType)
            
            var id: String {
                switch self {
                case .stantard:
                    return "standard"
                case .appFont(let type):
                    return "\(type)"
                }
            }
            
            init(from fontType: AppFont.FontType) {
                self = .appFont(fontType)
            }
            
            var title: String {
                return NSLocalizedString("fonts.type.\(id)", comment: "")
            }
        }
        
        var id: String { type.id }
        let type: FontsSectionType
        let fonts: [AppFontViewModel]
    }
    
    private let service: FontsServiceType
    private let preferences: Preferences
    private let subscriptionManager: SubscriptionManagerType
    private let subscribeScreenTrigger: () -> Void
    
    init(
        service: FontsServiceType,
        preferences: Preferences = .init(),
        subscriptionManager: SubscriptionManagerType = SubscriptionManagerFactory.create(),
        subscribeScreenTrigger: @escaping () -> Void
    ) {
        self.service = service
        self.preferences = preferences
        self.subscriptionManager = subscriptionManager
        self.subscribeScreenTrigger = subscribeScreenTrigger
        preferredFont = preferences.preferredFont
    }
    
    func changeSelectedFont(_ font: AppFontViewModel) {
        @Sendable func setFont() {
            preferredFont = font.font
            preferences.preferredFont = font.font
        }
        
        if font.zipFileURL != nil, subscriptionManager.isProUser() == false {
            subscribeScreenTrigger()
            return
        }
        
        if let url = font.zipFileURL, isFontInstalled(font) == false {
            loadingFonts.insert(font.font)
            Task(priority: .userInitiated) { [unowned self] in
                let fileURLs = try await service.loadFont(url: url)
                FontsHelper.registerFonts(fileURLs)
                loadingFonts.remove(font.font)
                DispatchQueue.main.async(execute: setFont)
            }
        } else {
            DispatchQueue.main.async(execute: setFont)
        }
    }
    
    private func isFontInstalled(_ font: AppFontViewModel) -> Bool {
        guard let url = font.zipFileURL else {
            return true
        }
        let folderURL = FileManager.default.fontsDirectoryURL.appendingPathComponent(url.deletingPathExtension().lastPathComponent)
        return FileManager.default.fileExists(atPath: folderURL.path)
    }
    
    func loadData() {
        Task(priority: TaskPriority.userInitiated) {
            try await loadFonts()
        }
    }
    
    private func loadFonts() async throws {
        let showNonCyrillicFonts = languageIdentifier != .ru
        let fonts = try await service.loadFonts()
        DispatchQueue.main.async {
            let grouped = Dictionary(grouping: fonts, by: \.type)
            var sections = grouped.keys.sorted(by: { $0.rawValue < $1.rawValue })
                .map { type -> FontsSection in
                    let fonts = grouped[type] ?? []
                    let fontViewModels = fonts
                        .filter { font in
                            return showNonCyrillicFonts ? true : font.supportsCyryllicCharacters
                        }
                        .map(AppFontViewModel.init)
                    return FontsSection(type: .init(from: type), fonts: fontViewModels)
                }
            sections.insert(FontsSection(type: .stantard, fonts: AppFont.standardFonts.map(AppFontViewModel.init)), at: 0)
            self.fonts = sections
            self.didLoadData = true
        }
    }
    
    static var placeholder: FontsViewModel {
        FontsViewModel(service: DemoFontsService(), subscribeScreenTrigger: {})
    }
    
}
