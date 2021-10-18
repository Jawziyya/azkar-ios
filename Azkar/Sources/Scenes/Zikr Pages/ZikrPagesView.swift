//
//  ZikrPagesView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 09.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import AudioPlayer
import Combine

struct ZikrPagesView: View, Equatable {

    static func == (lhs: ZikrPagesView, rhs: ZikrPagesView) -> Bool {
        lhs.viewModel.title == rhs.viewModel.title && lhs.page == rhs.page
    }

    let viewModel: ZikrPagesViewModel

    @State var page = 0

    var body: some View {
        pagerView
            .background(Color.background.edgesIgnoringSafeArea(.all))
            .onReceive(viewModel.selectedPage) { page in
                self.page = page
            }
    }

    var pagerView: some View {
        PageView(
            viewModel.azkar.map { zikr in
                LazyView(
                    ZikrView(viewModel: zikr)
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
        ZikrPagesView(
            viewModel: .placeholder
        )
    }

}
