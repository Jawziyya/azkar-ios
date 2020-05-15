//
//  AzkarListView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 06.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import AudioPlayer

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
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    func pagesView(_ index: Int) -> some View {
        ZStack {
            if UIDevice.current.isIpad {
                ZikrView(viewModel: self.viewModel.azkar[index])
            } else {
                LazyView(
                    ZikrPagesView(viewModel: self.viewModel, page: index)
                )
            }
        }
    }

}

struct AzkarListView_Previews: PreviewProvider {
    static var previews: some View {
        AzkarListView(viewModel: AzkarListViewModel(title: ZikrCategory.morning.title, azkar: [], preferences: Preferences()))
    }
}
