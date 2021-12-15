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
import SwiftUIX

struct ZikrPagesView: View, Equatable {

    static func == (lhs: ZikrPagesView, rhs: ZikrPagesView) -> Bool {
        lhs.viewModel.title == rhs.viewModel.title && lhs.viewModel.page == rhs.viewModel.page
    }

    @ObservedObject var viewModel: ZikrPagesViewModel

    var body: some View {
        pagerView
            .background(Color.background.edgesIgnoringSafeArea(.all))
            .onReceive(viewModel.selectedPage) { page in
                self.viewModel.page = page
            }
    }

    var pagerView: some View {
        PaginationView(
            axis: .horizontal,
            transitionStyle: .scroll,
            showsIndicators: false
        ) {
            ForEach(viewModel.azkar) { zikr in
                LazyView(
                    ZikrView(viewModel: zikr)
                )
            }
        }
        .currentPageIndex($viewModel.page)
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
