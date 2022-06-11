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
import SwiftUIDrag

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
            .overlay(
                SDView(
                    alignment: viewModel.alignZikrCounterByLeadingSide == true ? .bottomLeading : .bottomTrailing,
                    floating: [.bottomLeading, .bottomTrailing, .bottom],
                    collapse: [],
                    content: { geo, state in
                        Group {
                            let number = viewModel.currentZikrRemainingRepeatNumber
                            if viewModel.showCounterButton, number > 0 {
                                Text(number.description)
                                    .font(Font.system(size: 14, weight: .regular, design: .monospaced).monospacedDigit())
                                    .frame(minWidth: 20, minHeight: 20)
                                    .padding()
                                    .foregroundColor(Color.white)
                                    .background(Color.accent)
                                    .clipShape(Capsule())
                                    .padding()
                                    .onTapGesture {
                                        if viewModel.preferences.enableCounterHapticFeedback {
                                            Haptic.tapFeedback()
                                        }
                                        withAnimation(.easeInOut) {
                                            viewModel.incrementCounterForCurrentZikr()
                                        }
                                    }
                            }
                        }
                    }
                )
            )
    }

    var pagerView: some View {
        PaginationView(
            axis: .horizontal,
            transitionStyle: .scroll,
            showsIndicators: false
        ) {
            ForEach(viewModel.azkar) { zikr in
                LazyView(
                    ZikrView(
                        viewModel: zikr,
                        counterFinishedCallback: viewModel.goToNextZikrIfNeeded
                    )
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
