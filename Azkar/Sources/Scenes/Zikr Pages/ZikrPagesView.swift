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
            .overlay(alignment: viewModel.preferences.counterPosition.alignment) {
                Group {
                    if
                        viewModel.canUseCounter,
                        viewModel.preferences.counterType == .floatingButton,
                        viewModel.showCounterButton,
                        let currentZikrRemainingRepeatNumber = viewModel.currentZikrRemainingRepeatNumber,
                        currentZikrRemainingRepeatNumber > 0
                    {
                        counterButton(currentZikrRemainingRepeatNumber.description)
                    }
                }
            }
            .onAppear {
                AnalyticsReporter.reportScreen("Azkar Pages", className: viewName)
            }
    }
    
    func counterButton(_ repeats: String) -> some View {
        Button(action: {
            withAnimation(.smooth) {
                viewModel.incrementCurrentPageZikrCounter()
            }
        }, label: {
            Text(repeats)
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
                .foregroundStyle(Color.white)
                .background(.accent)
                .clipShape(Circle())
                .contextMenu {
                    Button(action: {
                        Task {
                            await viewModel.resetCounter()
                        }
                    }) {
                        Label(L10n.Common.resetCounter, systemImage: "arrow.counterclockwise")
                    }
                }
                .padding(.horizontal)
        })
        .frame(
            width: viewModel.preferences.counterSize.value,
            height: viewModel.preferences.counterSize.value
        )
        .padding(.horizontal)
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
                        incrementAction: viewModel.getIncrementPublisher(for: zikr),
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
