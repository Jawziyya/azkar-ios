//
//  MainMenuView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 12.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import AudioPlayer
import UserNotifications
import SwiftRichString

enum Constants {
    static var cornerRadius: CGFloat = 12
}

struct MainMenuView: View {

    typealias MenuSection = MainMenuViewModel.Section

    @ObservedObject var viewModel: MainMenuViewModel
    @Environment(\.horizontalSizeClass) var hSizeClass

    private var isIpad: Bool {
        UIDevice.current.isIpad
    }

    private var itemsBackgroundColor: SwiftUI.Color {
        Color(.secondarySystemGroupedBackground)
    }

    var body: some View {
        Group {
            ZStack {
                Color.dimmedBackground.edgesIgnoringSafeArea(.all)
                    .if(viewModel.enableEidBackground) { view in
                        view.overlay(
                            Image("eid_background")
                                .resizable()
                                .aspectRatio(contentMode: ContentMode.fill)
                                .edgesIgnoringSafeArea(.all)
                                .blendMode(.overlay)
                        )
                    }
                scrollView
                    .navigationTitle("")
            }
            .if(isIpad) {
                $0.frame(minWidth: 300)
            }
//            .handleNavigation(Router.shared.navigationPublisher)
        }
        .padding(.leading, isIpad ? 0.5 : 0) // Hack for proper allVisible split view mode.
        .environment(\.horizontalSizeClass, isIpad ? .regular : .compact)
        .attachEnvironmentOverrides(viewModel: EnvironmentOverridesViewModel(preferences: viewModel.preferences))
    }

    private var scrollView: some View {
        ScrollView(showsIndicators: false) {
            menuContent
        }
        .fixFlickering()
        .navigationBarTitle(viewModel.title)
    }

    private var menuContent: some View {
        VStack(spacing: 16) {

            Spacer(minLength: 16)

            // MARK: - Day & Night Azkar
            HStack(spacing: 16) {
                ForEach(viewModel.dayNightSectionModels) { item in
                    Button {
                        self.viewModel.navigateToCategory(item.category)
                    } label: {
                        MainMenuLargeGroup(item: item)
                    }
                }
                .foregroundColor(Color.text)
                .background(itemsBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            }

            // MARK: - Other Azkar
            VStack(spacing: 0) {
                if Date().isRamadan {
                    Button(action: {
                        self.viewModel.navigateToZikr(self.viewModel.fastingDua)
                    }, label: {
                        HStack {
                            MainMenuSmallGroup(item: AzkarMenuItem(category: ZikrCategory.other, imageName: "🌕", title: "Молитва разговения", color: Color.blue, count: nil, iconType: .emoji))
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.tertiaryText)
                                .padding(.trailing)
                        }
                        .padding(10)
                        .background(itemsBackgroundColor)
                    })
                }

                ForEach(viewModel.otherAzkarModels) { item in
                    Button {
                        self.viewModel.navigateToCategory(item.category)
                    } label: {
                        HStack {
                            MainMenuSmallGroup(item: item)
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.tertiaryText)
                                .padding(.trailing)
                        }
                        .padding(10)
                        .background(itemsBackgroundColor)
                    }
                }
            }
            .background(itemsBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))

            // MARK: - App Sections
            VStack(spacing: 0) {
                ForEach(viewModel.infoModels) { item in
                    Button {
                        self.viewModel.navigateToMenuItem(item)
                    } label: {
                        HStack {
                            MainMenuSmallGroup(item: item)
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.tertiaryText)
                                .padding(.trailing)
                        }
                        .padding(10)
                        .background(itemsBackgroundColor)
                    }
                }
            }
            .background(itemsBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))

            // MARK: - Additional Sections
            VStack {
                ForEach(viewModel.additionalMenuItems) { item in
                    Button {
                        item.action?()
                    } label: {
                        MainMenuSmallGroup(item: item, flip: true)
                            .padding()
                    }
                    .disabled(item.action == nil)
                    .background(itemsBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                }
            }

            VStack(spacing: 8) {
                Text(viewModel.fadl.text)
                    .font(Font.system(.body, design: .rounded).weight(.regular))
                    .tracking(1.2)
                    .foregroundColor(Color.text.opacity(0.7))

                Text(viewModel.fadl.source)
                    .font(Font.system(.caption2, design: .rounded).smallCaps())
                    .foregroundColor(Color.secondaryText.opacity(0.5))
            }
            .shadow(color: Color.text.opacity(0.5), radius: 0.5, x: 0.0, y: 0.05)
            .multilineTextAlignment(.center) 
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(viewModel: MainMenuViewModel(router: RootCoordinator(preferences: Preferences(), deeplinker: Deeplinker(), player: Player.init(player: AudioPlayer())), preferences: Preferences(), player: .test))
            .environment(\.colorScheme, .dark)
    }
}
