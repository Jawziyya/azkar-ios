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

    private let randomEmoji = ["🌕", "🌖", "🌗", "🌘", "🌒", "🌓", "🌔", "🌙", "🌸", "☘️", "🌳", "🌴", "🌱", "🌼", "💫", "🌎", "🌍", "🌏", "🪐", "✨", "❄️"].randomElement()!

    var body: some View {
        NavigationView {
            ZStack {
                Color.dimmedBackground.edgesIgnoringSafeArea(.all)
                    .if(Date().isEndOfRamadan) { view in
                        view.overlay(
                            Image("eid_background")
                                .resizable()
                                .overlay(Color.text.opacity(0.2))
                                .edgesIgnoringSafeArea(.all)
                        )
                    }
                scrollView
                    .navigationTitle("")
            }
            .if(isIpad) {
                $0.frame(minWidth: 300)
            }
            isIpad ? self.ipadDetailView : nil
        }
        .padding(.leading, isIpad ? 0.5 : 0) // Hack for proper allVisible split view mode.
        .environment(\.horizontalSizeClass, isIpad ? .regular : .compact)
        .attachEnvironmentOverrides(viewModel: EnvironmentOverridesViewModel(preferences: viewModel.preferences))
    }

    private var scrollView: some View {
        ScrollView {
            menuContent
        }
        .fixingFlickering() // Fixes the glitch bug on iOS 14.4
        .navigationBarTitle(Text("app-name", comment: "Name of the application.") + Text(" " + randomEmoji), displayMode: .automatic)
    }

    private var menuContent: some View {
        VStack(spacing: 16) {

            Spacer(minLength: 16)

            // MARK: - Day & Night Azkar
            HStack(spacing: 16) {
                ForEach(viewModel.dayNightSectionModels) { item in
                    Button {
                        self.viewModel.selectedAzkarItem = item.category
                    } label: {
                        MainMenuLargeGroup(item: item)
                    }
                    .navigate(using: $viewModel.selectedAzkarItem, destination: azkarDestination(for:))
                }
                .foregroundColor(Color.text)
                .background(itemsBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            }

            // MARK: - Other Azkar
            VStack(spacing: 0) {
                ForEach(viewModel.otherAzkarModels) { item in
                    Button {
                        self.viewModel.selectedAzkarListItem = item.category
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
                    .navigate(using: $viewModel.selectedAzkarListItem, destination: getZikrList)
                }
            }
            .background(itemsBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))

            // MARK: - App Sections
            VStack(spacing: 0) {
                ForEach(viewModel.infoModels) { item in
                    Button {
                        self.viewModel.selectedMenuItem = item
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
                    .navigate(using: $viewModel.selectedMenuItem, destination: self.menuDestination(for:))
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
                    .font(Font.textFont(.headline))
                    .tracking(1.2)
                    .foregroundColor(Color.text.opacity(0.7))

                Text(viewModel.fadl.source)
                    .font(Font.caption2.smallCaps())
                    .foregroundColor(Color.secondaryText.opacity(0.5))
            }
            .shadow(color: Color.text.opacity(0.5), radius: 0.5, x: 0.0, y: 0.05)
            .multilineTextAlignment(.center) 
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }

    private var ipadDetailView: some View {
        Color.secondaryBackground
        .overlay(
            Text("root.pick-section", comment: "Pick section label.")
                .font(Font.title.smallCaps())
                .foregroundColor(Color.secondary)
            ,
            alignment: .center
        )
        .edgesIgnoringSafeArea(.all)
    }

    @ViewBuilder
    private func getZikrList(_ model: ZikrCategory) -> some View {
        let viewModel = self.viewModel.getZikrPagesViewModel(for: model)

        if isIpad {
            AzkarListView(viewModel: viewModel)
        } else {
            ZStack {
                if model == .afterSalah {
                    ZikrPagesView(viewModel: viewModel)
                        .navigationBarTitle("", displayMode: .inline)
                } else {
                    AzkarListView(viewModel: viewModel)
                }
            }
        }
    }

    @ViewBuilder
    private func azkarDestination(for model: ZikrCategory) -> some View {
        let viewModel = self.viewModel.getZikrPagesViewModel(for: model)
        ZStack {
            if isIpad {
                getZikrList(model)
            } else {
                ZikrPagesView(viewModel: viewModel)
            }
        }
        .navigationBarTitle(viewModel.title, displayMode: .inline)
    }

    @ViewBuilder
    private func menuDestination(for item: AzkarMenuOtherItem) -> some View {
        switch item.groupType {
        case .about:
            AppInfoView(viewModel: AppInfoViewModel(prerences: viewModel.preferences))
        case .settings:
            SettingsView(viewModel: viewModel.settingsViewModel)
        default:
            EmptyView()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(viewModel: MainMenuViewModel(preferences: Preferences(), player: .test))
            .environment(\.colorScheme, .dark)
    }
}
