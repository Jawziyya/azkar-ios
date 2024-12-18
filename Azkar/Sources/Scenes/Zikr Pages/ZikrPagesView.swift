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
import Extensions
import Library

struct ZikrPagesView: View, Equatable {

    static func == (lhs: ZikrPagesView, rhs: ZikrPagesView) -> Bool {
        lhs.viewModel.title == rhs.viewModel.title && lhs.viewModel.page == rhs.viewModel.page
    }

    @ObservedObject var viewModel: ZikrPagesViewModel
    @State var readingMode: ZikrReadingMode?

    var body: some View {
        pagerView
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    HStack {
                        Button(systemImage: .squareAndArrowUp, action: viewModel.shareCurrentZikr)
                        
                        Button(systemImage: .textformat, action: viewModel.navigateToTextSettings)
                    }
                }
            }
            .background(Color.background.edgesIgnoringSafeArea(.all))
            .overlay(
                Group {
                    if viewModel.canUseCounter, viewModel.preferences.counterType == .floatingButton {
                        counterButton
                    }
                }
            )
            .onAppear {
                AnalyticsReporter.reportScreen("Azkar Pages", className: viewName)
            }
    }

    var counterButton: some View {
        SDView(
            alignment: viewModel.alignZikrCounterByLeadingSide ? .bottomLeading : .bottomTrailing,
            floating: [.bottom],
            collapse: [],
            visibleSize: CGSize(
                width: viewModel.preferences.counterSize.value,
                height: viewModel.preferences.counterSize.value
            ),
            content: { _, state in
                ExecuteCallView {
                    if state != .expanded {
                        viewModel.setZikrCounterAlignment(byLeftSide: state.isLeading)
                    }
                }
                let number = viewModel.currentZikrRemainingRepeatNumber
                if viewModel.showCounterButton, number > 0 {
                    Text(number.description)
                        .font(Font.system(
                            size: viewModel.preferences.counterSize.value / 3,
                            weight: .regular,
                            design: .monospaced).monospacedDigit()
                        )
                        .minimumScaleFactor(0.25)
                        .padding()
                        .frame(
                            width: viewModel.preferences.counterSize.value,
                            height: viewModel.preferences.counterSize.value
                        )
                        .foregroundColor(Color.white)
                        .background(Color.accent)
                        .clipShape(Circle())
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
        .initialPageIndex(viewModel.initialPage)
        .currentPageIndex($viewModel.page)
        .edgesIgnoringSafeArea(.bottom)
        .environment(\.zikrReadingMode, readingMode ?? viewModel.preferences.zikrReadingMode)
        .onReceive(viewModel.preferences.$zikrReadingMode) { newMode in
            readingMode = newMode
        }
    }

}

#Preview("ZikrPages") {
    NavigationView {
        ZikrPagesView(viewModel: ZikrPagesViewModel.placeholder)
    }
}
