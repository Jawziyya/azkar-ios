import SwiftUI

struct PageView<Page: View>: View {
    var viewControllers: [UIHostingController<Page>]
    @Binding var currentPage: Int
    private let infinityScroll: Bool
    private let displayPageControl: Bool

    init(_ views: [Page], currentPage: Binding<Int>, infinityScroll: Bool, displayPageControl: Bool) {
        self.viewControllers = views.map {
            UIHostingController(rootView: $0)
        }
        self.infinityScroll = infinityScroll
        self.displayPageControl = displayPageControl
        self._currentPage = currentPage
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(controllers: viewControllers, currentPage: $currentPage, infinityScroll: infinityScroll)
            if displayPageControl {
                PageControl(numberOfPages: viewControllers.count, currentPage: $currentPage)
                    .padding(.trailing)
            }
        }
    }
}

//struct PageView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageView(features.map { FeatureCard(landmark: $0) })
//            .aspectRatio(3 / 2, contentMode: .fit)
//    }
//}
