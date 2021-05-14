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
        ScrollView(.vertical, showsIndicators: true) {
            list
        }
        .navigationBarTitle(viewModel.title, displayMode: .inline)
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }

    var list: some View {
        LazyVStack(alignment: HorizontalAlignment.leading, spacing: 8) {
            ForEach(viewModel.azkar.indexed(), id: \.1) { index, vm in
                NavigationLink(destination: self.pagesView(index)) {
                    HStack {
                        Text(vm.title)
                            .contentShape(Rectangle())
                        Spacer(minLength: 8)
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .contentShape(Rectangle())
                }
                .isDetailLink(true)
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
        AzkarListView(viewModel: AzkarListViewModel(category: .other, title: ZikrCategory.morning.title, azkar: [], preferences: Preferences()))
    }
}
