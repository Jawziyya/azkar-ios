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

    @Namespace private var pageSelectionNamespace
    @State private var scrollProxy: ScrollViewProxy?
    
    @Environment(\.appTheme) var appTheme
    @Environment(\.colorTheme) var colorTheme

    private let pageIndicatorHeight: CGFloat = 56

    private var selectablePageIndices: Range<Int> {
        viewModel.pages.indices.dropLast()
    }

    var showPageIndicators = false

    var body: some View {
        VStack(spacing: 8) {
            pagerView
            if showPageIndicators {
                bottomPageOverlay
            }
        }
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
        .currentPageIndex($viewModel.page.animation(.spring))
        .edgesIgnoringSafeArea(.bottom)
        .environment(\.zikrReadingMode, readingMode ?? viewModel.preferences.zikrReadingMode)
        .onReceive(viewModel.preferences.$zikrReadingMode) { newMode in
            readingMode = newMode
        }
    }

    var bottomPageOverlay: some View {
        GeometryReader { geo in
            PagesPreviewView(
                selectedPage: $viewModel.page,
                pageCount: viewModel.pages.count - 1,
                height: 40,
                cornerRadius: 6,
                spacing: 4,
                safeAreaBottom: geo.safeAreaInsets.bottom,
                indicatorView: { idx, isSelected in
                    pageIndicator(index: idx, isSelected: isSelected)
                }
            )
            .frame(height: min(geo.size.height, pageIndicatorHeight))
            .edgesIgnoringSafeArea(.bottom)
        }
        .frame(maxHeight: pageIndicatorHeight)
        .allowsHitTesting(true)
    }
    
    @ViewBuilder private func pageIndicator(index: Int, isSelected: Bool) -> some View {
        let viewModel = self.viewModel.azkar[index]
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(isSelected ? colorTheme.getColor(.accent).opacity(0.5) : colorTheme.getColor(.contentBackground))
                .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)
            VStack(spacing: 0) {
                Text("\(index + 1)")
                    .font(.caption)
                let remainingRepeatsNumber = viewModel.remainingRepeatsNumber ?? 0
                if remainingRepeatsNumber == 0 {
                    Text("✓")
                        .font(.caption2)
                }
            }
            .foregroundColor(isSelected ? Color.white : colorTheme.getColor(.tertiaryText))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .minimumScaleFactor(0.15)
        }
    }

}

#Preview("ZikrPages") {
    NavigationView {
        ZikrPagesView(viewModel: ZikrPagesViewModel.placeholder)
    }
}
