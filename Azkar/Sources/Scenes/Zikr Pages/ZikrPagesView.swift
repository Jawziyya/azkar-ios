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
                Group {
                    if viewModel.canUseCounter, viewModel.preferences.counterType == .floatingButton {
                        counterButton
                    }
                }
            )
    }

    var counterButton: some View {
        SDView(
            alignment: viewModel.alignZikrCounterByLeadingSide ? .bottomLeading : .bottomTrailing,
            floating: [.bottom],
            collapse: [],
            content: { geo, state in
                ExecuteCallView {
                    if state != .expanded {
                        viewModel.setZikrCounterAlignment(byLeftSide: state.isLeading)
                    }
                }
                let number = viewModel.currentZikrRemainingRepeatNumber
                if viewModel.showCounterButton, number > 0 {
                    Text(number.description)
                        .font(Font.system(size: 14, weight: .regular, design: .monospaced).monospacedDigit())
                        .frame(minWidth: 20, minHeight: 20)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.accent)
                        .clipShape(Capsule())
                        .padding(.horizontal)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                viewModel.incrementCurrentPageZikrCounter()
                            }
                        }
                }
            }
        )
    }

    var pagerView: some View {
        PaginationView(
            axis: .horizontal,
            transitionStyle: .scroll,
            showsIndicators: false
        ) {
            ForEach(viewModel.azkar) { zikr in
                ZikrView(
                    viewModel: zikr,
                    incrementAction: viewModel.getIncrementPublisher(for: zikr),
                    counterFinishedCallback: viewModel.goToNextZikrIfNeeded
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
