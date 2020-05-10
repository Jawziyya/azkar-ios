//
//  ZikrPagesView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 09.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import AudioPlayer

struct ZikrPagesView: View, Equatable {

    static func == (lhs: ZikrPagesView, rhs: ZikrPagesView) -> Bool {
        lhs.viewModel.title == rhs.viewModel.title
    }

    let viewModel: ZikrPagesViewModel

    @State var page = 0

//    @State private var showSettings = false

    var body: some View {
        pagerView
            .background(Color.background.edgesIgnoringSafeArea(.all))
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
//                SettingsView(viewModel: SettingsViewModel(preferences: Preferences()))
//                    .embedInNavigation()
//            }
    }

    var pagerView: some View {
        PageView(
            viewModel.azkar.map { zikr in
                LazyView(
                    ZikrView(viewModel: zikr, player: self.viewModel.player)
                        .environmentObject(self.viewModel.preferences)
                )
            },
            currentPage: $page,
            infinityScroll: false,
            displayPageControl: false
        )
        .edgesIgnoringSafeArea(.bottom)
    }

}

struct ZikrPagesView_Previews: PreviewProvider {

    static var previews: some View {
        ZikrPagesView(viewModel: ZikrPagesViewModel(type: .morning, azkar: Zikr.data, preferences: Preferences(), player: Player.test))
    }

}
