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

private func leadingPadding(_ geometry: GeometryProxy) -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == .pad {
        return 0.5
    }
    return 0
}

struct MainMenuView: View {

    typealias Section = MainMenuViewModel.Section

    var viewModel: MainMenuViewModel
    @Environment(\.colorScheme) var colorScheme

    let groupBackgroundElementID = UUID().uuidString

    var body: some View {
        NavigationView {
            self.remindersStyleMenu
                .navigationBarTitle(Text("Азкары"), displayMode: .inline)
            UIDevice.current.isIpad ? self.ipadDetailView : nil
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .padding(.leading, UIDevice.current.isIpad ? 1 : 0) // Hack for proper allVisible split view mode.
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }

    private var ipadDetailView: some View {
        Color.secondaryBackground
        .overlay(
            Text("Выберите раздел")
                .font(Font.title.smallCaps())
                .foregroundColor(Color.secondary)
            ,
            alignment: .center
        )
        .edgesIgnoringSafeArea(.all)
    }

    private var remindersStyleMenu: some View {
        ASCollectionView {
            sections
        }
        .layout(menuLayout)
        .contentInsets(.init(top: 20, left: 0, bottom: 20, right: 0))
        .alwaysBounceVertical()
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
    }

    private var sections: [ASCollectionViewSection<Section>] {
        var sections = [
        ASCollectionViewSection<Section>(id: .dayNight, data: viewModel.dayNightSectionModels) { item, _ in

            NavigationLink(destination: self.azkarsDestination(for: item)) {
                MainMenuLargeGroup(item: item)
            }
            .isDetailLink(false)
            .buttonStyle(PlainButtonStyle())
        },

        ASCollectionViewSection<Section>(id: .afterSalah, data: viewModel.otherAzkarModels) { item, ctx in
            VStack(spacing: 0) {
                NavigationLink(destination: self.zikrList(item)) {
                    HStack {
                        MainMenuSmallGroup(item: item)
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.tertiaryText)
                            .padding(.trailing)
                    }
                }
                .isDetailLink(false)
                if !ctx.isLastInSection {
                    Divider()
                }
            }
        },

        ASCollectionViewSection<Section>(id: .info, data: viewModel.infoModels) { item, ctx in
            VStack(spacing: 0) {
                NavigationLink(destination: self.destination(for: item)) {
                    HStack {
                        MainMenuSmallGroup(item: item)
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.tertiaryText)
                            .padding()
                    }
                }
                if !ctx.isLastInSection {
                    Divider()
                }
            }
        }
//        .sectionHeader {
//            Text("Информация")
//                .font(Font.headline.weight(.regular))
//                .foregroundColor(Color.secondaryText)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding()
//        }

        ]

        if let vm = viewModel.notificationAccessModel {
            let section = ASCollectionViewSection<Section>.init(id: .notificationsAccess) {
                Button(action: {
                    print("OK")
                }, label: {
                    Text(vm.title)
                        .foregroundColor(Color.white)
                        .padding()
                        .lineLimit(nil)
                })
            }
            sections.append(section)
        }

        return sections
    }

    private func zikrList(_ model: AzkarMenuItem) -> some View {
        let viewModel = self.getZikrPagesViewModel(for: model.category)

        return ZStack {
            if UIDevice.current.isIpad {
                LazyView(
                    AzkarListView(viewModel: viewModel)
                )
            } else {
                LazyView(
                    ZStack {
                        if model.category == .afterSalah {
                            ZikrPagesView(viewModel: viewModel)
                        } else {
                            AzkarListView(viewModel: viewModel)
                        }
                    }
                )
            }
        }
        .environmentObject(viewModel.preferences)
    }

    private func getZikrPagesViewModel(for category: ZikrCategory) -> ZikrPagesViewModel {
        ZikrPagesViewModel(type: category, azkar: viewModel.azkarForCategory(category), preferences: viewModel.preferences, player: viewModel.player)
    }

    private func azkarsDestination(for model: AzkarMenuItem) -> some View {
        let viewModel = self.getZikrPagesViewModel(for: model.category)
        return ZStack {
            if UIDevice.current.isIpad {
                zikrList(model)
            } else {
                LazyView(
                    ZikrPagesView(viewModel: viewModel)
                )
            }
        }
        .environmentObject(viewModel.preferences)
        .navigationBarTitle(viewModel.title)
    }

    private func destination(for item: AzkarMenuOtherItem) -> AnyView {
        switch item.groupType {
        case .legal:
            return AppInfoView(viewModel: AppInfoViewModel()).eraseToAny()
        case .settings:
            return SettingsView(viewModel: self.viewModel.settingsViewModel).eraseToAny()
        default:
            return EmptyView().eraseToAny()
        }
    }

    private var menuLayout: ASCollectionLayout<Section> {
        ASCollectionLayout<Section>(interSectionSpacing: 20) { sectionID in
            switch sectionID {
            case .dayNight:
                return .grid(
                    layoutMode: .fixedNumberOfColumns(2),
                    itemSpacing: 20,
                    lineSpacing: 20,
                    itemSize: .estimated(90)
                )
            case .afterSalah, .info, .notificationsAccess:
                return ASCollectionLayoutSection {
                    let itemSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(80))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let groupSize = NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(80))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

                    let supplementarySize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
                    let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: supplementarySize,
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top)
                    let footerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: supplementarySize,
                        elementKind: UICollectionView.elementKindSectionFooter,
                        alignment: .bottom)
                    section.boundarySupplementaryItems = [headerSupplementary, footerSupplementary]

                    let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: self.groupBackgroundElementID)
                    sectionBackgroundDecoration.contentInsets = section.contentInsets
                    section.decorationItems = [sectionBackgroundDecoration]

                    return section
                }
            }
        }
        .decorationView(GroupBackground.self, forDecorationViewOfKind: groupBackgroundElementID)
    }

}

struct GroupBackground: View, Decoration {
    let cornerRadius: CGFloat = 12
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(.secondarySystemGroupedBackground))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(viewModel: MainMenuViewModel(preferences: Preferences(), player: .test))
    }
}
