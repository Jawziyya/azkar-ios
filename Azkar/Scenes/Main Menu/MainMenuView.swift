//
//  MainMenuView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 12.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import ASCollectionView
import AudioPlayer
import UserNotifications

enum Constants {
    static var cornerRadius: CGFloat = 12
}

struct MainMenuView: View {

    typealias MenuSection = MainMenuViewModel.Section

    @ObservedObject var viewModel: MainMenuViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var hSizeClass

    private var isIpad: Bool {
        UIDevice.current.isIpad
    }

    private var itemsBackgroundColor: Color {
        if colorScheme == .dark {
            return Color.secondaryBackground
        } else {
            return Color.background
        }
    }

    private var backgroundColor: Color {
        if colorScheme == .dark {
            return Color.background
        } else {
            return Color.secondaryBackground
        }
    }

    private let randomEmoji = ["🌕", "🌖", "🌗", "🌘", "🌒", "🌓", "🌔", "🌙", "🌸", "☘️", "🌳", "🌴", "🌱", "🌼", "💫", "🌎", "🌍", "🌏", "🪐", "✨", "❄️"].randomElement()!

    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
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
        VStack {
            Spacer(minLength: 16)

            VStack(spacing: 16) {

                HStack(spacing: 16) {
                    ForEach(viewModel.dayNightSectionModels) { item in
                        NavigationButton(isDetail: false) {
                            self.viewModel.selectedMenuItem = item
                        } destination: {
                            self.azkarsDestination(for: item)
                        } label: {
                            MainMenuLargeGroup(item: item)
                        }
                    }
                    .background(itemsBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                }

                VStack(spacing: 0) {
                    ForEach(viewModel.otherAzkarModels) { item in
                        NavigationButton(isDetail: false) {
                            self.viewModel.selectedMenuItem = item
                        } destination: {
                            self.getZikrList(item)
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

                VStack(spacing: 0) {
                    ForEach(viewModel.infoModels) { item in
                        NavigationButton(isDetail: false, destination: {
                            self.destination(for: item)
                        }, label: {
                            HStack {
                                MainMenuSmallGroup(item: item)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color.tertiaryText)
                                    .padding(.trailing)
                            }
                            .padding(10)
                            .background(itemsBackgroundColor)
                        })
                    }
                }
                .background(itemsBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))

                viewModel.notificationAccessModel.flatMap { vm in
                    Button(action: {
                        UNUserNotificationCenter.current()
                            .requestAuthorization(options: [.alert, .sound, ]) { (granted, error) in
                                self.viewModel.hideNotificationsAccessMessage()
                                guard granted else {
                                    return
                                }
                                self.viewModel.preferences.enableNotifications = true
                            }
                    }, label: {
                        MainMenuSmallGroup(item: AzkarMenuOtherItem(icon: "app.badge", title: vm.title, color: Color.orange), flip: true)
                            .padding()
                            .background(itemsBackgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    })
                }

            }

            Spacer(minLength: 16)
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

    private func getZikrList(_ model: AzkarMenuItem) -> some View {
        let viewModel = self.getZikrPagesViewModel(for: model.category)

        return ZStack {
            if isIpad {
                LazyView(
                    AzkarListView(viewModel: viewModel)
                )
            } else {
                LazyView(
                    ZStack {
                        if model.category == .afterSalah {
                            ZikrPagesView(viewModel: viewModel)
                                .navigationBarTitle("", displayMode: .inline)
                        } else {
                            AzkarListView(viewModel: viewModel)
                        }
                    }
                )
            }
        }
    }

    private func getZikrPagesViewModel(for category: ZikrCategory) -> ZikrPagesViewModel {
        ZikrPagesViewModel(title: category.title, azkar: viewModel.azkarForCategory(category), preferences: viewModel.preferences)
    }

    private func azkarsDestination(for model: AzkarMenuItem) -> some View {
        let viewModel = self.getZikrPagesViewModel(for: model.category)
        return ZStack {
            if isIpad {
                getZikrList(model)
            } else {
                LazyView(
                    ZikrPagesView(viewModel: viewModel)
                )
            }
        }
        .navigationBarTitle(viewModel.title, displayMode: .inline)
    }

    private func destination(for item: AzkarMenuOtherItem) -> AnyView {
        switch item.groupType {
        case .legal:
            return AppInfoView(viewModel: AppInfoViewModel(prerences: viewModel.preferences)).eraseToAny()
        case .settings:
            return SettingsView(viewModel: viewModel.settingsViewModel).eraseToAny()
        default:
            return EmptyView().eraseToAny()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(viewModel: MainMenuViewModel(preferences: Preferences(), player: .test))
            .environment(\.colorScheme, .dark)
    }
}
