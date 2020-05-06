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

struct MainMenuView: View {

    typealias Section = MainMenuViewModel.Section

    var viewModel: MainMenuViewModel
    @Environment(\.colorScheme) var colorScheme

    let groupBackgroundElementID = UUID().uuidString

    var body: some View {
        remindersStyleMenu
            .navigationBarTitle(Text("Азкары"), displayMode: .inline)
            .background(Color.background.edgesIgnoringSafeArea(.all))
            .embedInNavigation()
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

            NavigationLink(destination: self.zikrPages(item)) {
                MainMenuLargeGroup(item: item)
            }
            .buttonStyle(PlainButtonStyle())
        },

        ASCollectionViewSection<Section>(id: .afterSalah, data: viewModel.otherAzkarModels) { item, ctx in
            VStack(spacing: 0) {
                NavigationLink(destination: self.zikrPages(item)) {
                    HStack {
                        MainMenuSmallGroup(item: item)
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.tertiaryText)
                            .padding(.trailing)
                    }
                }
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

    private func zikrPages(_ model: AzkarMenuItem) -> some View {
        LazyView(
            ZikrPagesView(viewModel: ZikrPagesViewModel(type: model.category, azkar: self.viewModel.azkarForCategory(model.category), player: Player(player: self.viewModel.audioPlayer), preferences: self.viewModel.preferences))
                .equatable()
                .environmentObject(self.viewModel.preferences)
        )
    }

    private func destination(for item: AzkarMenuOtherItem) -> AnyView {
        switch item.groupType {
        case .legal:
            return AppInfoView(viewModel: .init()).eraseToAny()
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
        MainMenuView(viewModel: .init(audioPlayer: AudioPlayer(), preferences: .init()))
    }
}
