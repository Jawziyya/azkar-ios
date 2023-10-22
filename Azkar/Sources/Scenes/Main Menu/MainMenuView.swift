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
import Entities

enum Constants {
    static var cornerRadius: CGFloat = 12
    static var windowSafeAreaInsets: EdgeInsets = .zero
}

struct MainMenuView: View {

    @ObservedObject var viewModel: MainMenuViewModel
    @Environment(\.colorScheme) var colorScheme

    private var isIpad: Bool {
        UIDevice.current.isIpad
    }

    private var itemsBackgroundColor: SwiftUI.Color {
        Color.contentBackground
    }

    var body: some View {
        content
            .environment(\.horizontalSizeClass, isIpad ? .regular : .compact)
            .saturation(viewModel.preferences.colorTheme == .ink ? 0 : 1)
            .attachEnvironmentOverrides(viewModel: EnvironmentOverridesViewModel(preferences: viewModel.preferences))
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            Constants.windowSafeAreaInsets = proxy.safeAreaInsets
                        }
                }
            )
    }
    
    private var content: some View {
        scrollView
            .background(
                Color.background
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        ZStack {
                            if viewModel.enableEidBackground {
                                Image("eid_background")
                                    .resizable()
                                    .aspectRatio(contentMode: ContentMode.fill)
                                    .edgesIgnoringSafeArea(.all)
                                    .blendMode(.overlay)
                            }
                        }
                    )
            )
    }

    private var scrollView: some View {
        ScrollView(showsIndicators: false) {
            menuContent
        }
        .navigationBarTitle(viewModel.title)
    }

    private var menuContent: some View {
        VStack(spacing: 16) {

            Spacer(minLength: 16)

            // MARK: - Day & Night Azkar
            GeometryReader { proxy in
                HStack(spacing: 16) {
                    ForEach(viewModel.getDayNightSectionModels(isDarkModeEnabled: colorScheme == .dark)) { item in
                        Button {
                            self.viewModel.navigateToCategory(item.category)
                        } label: {
                            MainMenuLargeGroup(viewModel: item)
                        }
                        .frame(width: (proxy.size.width - 16)/2)
                        .frame(height: 120)
                    }
                    .foregroundColor(Color.text)
                    .background(itemsBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 1)
                }
            }
            .frame(height: 120)

            // MARK: - Other Azkar
            VStack(spacing: 0) {
                if Date().isRamadan, let dua = viewModel.fastingDua {
                    Button(action: {
                        self.viewModel.navigateToZikr(dua)
                    }, label: {
                        HStack {
                            MainMenuSmallGroup(item: AzkarMenuItem(category: ZikrCategory.other, imageName: "🌕", title: dua.title ?? "", color: Color.blue, count: nil, iconType: .emoji))
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
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 1)

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
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 1)

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
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 1)

            if let fadl = viewModel.fadl {
                VStack(spacing: 8) {
                    Text(fadl.text)
                        .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .caption1))
                        .tracking(1.2)
                        .foregroundColor(Color.text.opacity(0.7))

                    Text(fadl.source)
                        .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .caption2))
                        .foregroundColor(Color.secondaryText.opacity(0.5))
                }
                .shadow(color: Color.text.opacity(0.5), radius: 0.5, x: 0.0, y: 0.05)
                .multilineTextAlignment(.center)
                .padding()
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 1)
            }
        }
        .padding(.horizontal)
    }

}

#Preview {
    MainMenuView(viewModel: MainMenuViewModel.placeholder)
        .environment(\.colorScheme, .light)
}
