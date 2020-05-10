//
//  AzkarListView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 06.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import AudioPlayer
import ASCollectionView

typealias AzkarListViewModel = ZikrPagesViewModel

struct AzkarListView: View {

    let viewModel: AzkarListViewModel

    var body: some View {
        list
            .navigationBarTitle(viewModel.title)
    }

    var list: some View {
        List {
            ForEach(viewModel.azkar.indexed(), id: \.0) { index, vm in
                NavigationLink(destination: self.pagesView(index)) {
                    Text(vm.title)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    func pagesView(_ index: Int) -> some View {
        ZStack {
            if UIDevice.current.isIpad {
                ZikrView(viewModel: self.viewModel.azkar[index], player: viewModel.player)
            } else {
                LazyView(
                    ZikrPagesView(viewModel: self.viewModel, page: index)
                )
            }
        }
    }

    var collectionView: some View {
        ASCollectionView(section: section)
            .alwaysBounceVertical(true)
            .scrollIndicatorsEnabled(horizontal: false, vertical: true)
            .shouldInvalidateLayoutOnStateChange(true)
            .shouldAttemptToMaintainScrollPositionOnOrientationChange(maintainPosition: true)
            .layout(self.layout)
            .contentInsets(.init(top: 16, left: 0, bottom: 16, right: 0))
            .edgesIgnoringSafeArea(.bottom)
    }

    private var layout: ASCollectionLayout<Int> {
        ASCollectionLayout(scrollDirection: .vertical, interSectionSpacing: 0) {
            .list(itemSize: .estimated(50), spacing: 8, sectionInsets: .zero)
        }
    }

    var section: ASCollectionViewSection<Int> {
        ASCollectionViewSection(id: 0, data: viewModel.azkar) { (zikr, ctx) in
            NavigationLink(destination: self.pagesView(self.viewModel.azkar.firstIndex(of: zikr)!)) {
                HStack {
                    Text(zikr.title)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

}

struct AzkarListView_Previews: PreviewProvider {
    static var previews: some View {
        AzkarListView(viewModel: AzkarListViewModel(type: .morning, azkar: Zikr.data, preferences: Preferences(), player: Player.test))
    }
}
