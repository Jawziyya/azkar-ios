//
//  ZikrPagesView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 09.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import ASCollectionView
import AudioPlayer

struct ZikrPagesView: View, Equatable {

    static func == (lhs: ZikrPagesView, rhs: ZikrPagesView) -> Bool {
        lhs.viewModel.title == rhs.viewModel.title
    }

    let viewModel: ZikrPagesViewModel

    @State private var page = 0

//    @State private var showSettings = false

    var body: some View {
        collectionView
            .navigationBarTitle(viewModel.title)
            .background(Color.background.edgesIgnoringSafeArea(.all))
            .onDisappear {
                self.viewModel.player.stop()
            }
//            .navigationBarItems(trailing:
//                Button(action: {
//                    self.showSettings = true
//                }, label: {
//                    Image(systemName: "gear")
//                        .foregroundColor(Color.accent)
//                        .padding()
//                })
//            )
//            .sheet(isPresented: $showSettings) {
//                SettingsView(viewModel: self.viewModel.settingsViewModel)
//                    .embedInNavigation()
//            }
    }

    var collectionView: some View {
        ASCollectionView(section: section)
            .alwaysBounceVertical(true)
            .scrollIndicatorsEnabled(horizontal: false, vertical: true)
            .shouldInvalidateLayoutOnStateChange(true)
            .shouldAttemptToMaintainScrollPositionOnOrientationChange(maintainPosition: true)
            .layout(self.nsLayout)
            .edgesIgnoringSafeArea(.bottom)
    }

    private var section: ASCollectionViewSection<Int> {
        ASCollectionViewSection(
                id: 0,
                data: viewModel.azkar
            )
            { (zikr, context) -> AnyView in
                let viewModel = ZikrViewModel(zikr: zikr, player: self.viewModel.player)
                let zikrView = ZikrView(viewModel: viewModel)
                    .environmentObject(self.viewModel.preferences)
                let view = LazyView(
                    zikrView
                )
                return view.eraseToAny()
            }
    }

    private var layout: ASCollectionLayout<Int> {
        ASCollectionLayout(scrollDirection: .horizontal, interSectionSpacing: 0) { () -> ASCollectionLayoutSection in
            ASCollectionLayoutSection.list(spacing: 0, sectionInsets: .zero)
        }
    }

    private var flowLayout: ASCollectionLayout<Int> {
        ASCollectionLayout {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.sectionInset = .zero
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            return layout
        }
    }

    private var nsLayout: ASCollectionLayout<Int> {
        ASCollectionLayout(scrollDirection: .vertical, interSectionSpacing: 0) {
            ASCollectionLayoutSection { environment in
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                )

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)),
                    subitem: item,
                    count: 1
                )

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.contentInsets = .zero
                section.orthogonalScrollingBehavior = .groupPaging
                return section
            }
        }
    }

}

struct ZikrPagesView_Previews: PreviewProvider {

    static var previews: some View {
        ZikrPagesView(viewModel: .init(type: .morning, azkar: Zikr.data, player: .test, preferences: .init()))
    }

}
