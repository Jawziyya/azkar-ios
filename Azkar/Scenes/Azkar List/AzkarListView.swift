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

    @State private var selection: Set<ZikrViewModel>?

    var body: some View {
        list
            .navigationBarTitle(viewModel.title, displayMode: .inline)
    }

    var list: some View {
        List(viewModel.azkar.indexed(), id: \.1, selection: $selection) { index, vm in
            NavigationLink(destination: self.pagesView(index)) {
                Text(vm.title)
                    .padding(.vertical)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .listStyle(PlainListStyle())
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
