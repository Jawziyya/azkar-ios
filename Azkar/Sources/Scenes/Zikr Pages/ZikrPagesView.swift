import SwiftUI
import AudioPlayer
import Combine
import SwiftUIX
import Extensions
import Library
import WidgetKit

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
                    let page = viewModel.pages[viewModel.page]
                    if page != .readingCompletion {
                        HStack {
                            Button(systemImage: .squareAndArrowUp, action: viewModel.shareCurrentZikr)
                            
                            Button(systemImage: .textformat, action: viewModel.navigateToTextSettings)
                        }
                    }
                }
            }
            .background(.background, ignoreSafeArea: .all)
            .onAppear {
                AnalyticsReporter.reportScreen("Azkar Pages", className: viewName)
            }
    }
    
    var pagerView: some View {
        PaginationView(
            axis: .horizontal,
            transitionStyle: .scroll,
            showsIndicators: false
        ) {
            ForEach(viewModel.pages) { pageType in
                switch pageType {
                case .zikr(let zikr):
                    ZikrView(
                        viewModel: zikr,
                        counterFinishedCallback: viewModel.goToNextZikrIfNeeded
                    )
                case .readingCompletion:
                    ReadingCompletionView(
                        isCompleted: !viewModel.hasRemainingRepeats,
                        markAsCompleted: {
                            await viewModel.markCurrentCategoryAsCompleted()
                            WidgetCenter.shared.reloadTimelines(ofKind: "AzkarCompletionWidgets")
                        }
                    )
                }
            }
        }
        .initialPageIndex(viewModel.initialPage)
        .currentPageIndex($viewModel.page.animation(.smooth))
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
