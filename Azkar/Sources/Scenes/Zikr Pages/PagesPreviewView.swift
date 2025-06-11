import SwiftUI
import Extensions

struct PagesPreviewView<Indicator: View>: View {
    @Environment(\.colorTheme) var colorTheme

    @Binding var selectedPage: Int

    let pageCount: Int
    var height: CGFloat = 56
    var cornerRadius: CGFloat = 10
    var spacing: CGFloat = 10
    var safeAreaBottom: CGFloat = 0

    var indicatorView: (_ idx: Int, _ isSelected: Bool) -> Indicator

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: spacing) {
                    ForEach(0..<pageCount, id: \.self) { idx in
                        indicatorView(idx, idx == selectedPage)
                            .aspectRatio(3/4, contentMode: .fit)
                            .frame(height: height)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedPage = idx
                                    proxy.scrollTo(idx, anchor: .center)
                                }
                            }
                            .id(idx)
                    }
                }
                .padding(.horizontal, 10)
                .frame(height: height)
            }
            .onChange(of: selectedPage) { newPage in
                withAnimation(.easeInOut) {
                    proxy.scrollTo(newPage, anchor: .center)
                }
            }
        }
        .frame(height: height)
        .padding(.bottom, safeAreaBottom + 4)
        .padding(.horizontal, 0)
    }
}

// Default indicator for convenience
extension PagesPreviewView where Indicator == DefaultZikrPageIndicator {
    init(
        selectedPage: Binding<Int>,
        pageCount: Int,
        height: CGFloat = 56,
        cornerRadius: CGFloat = 10,
        spacing: CGFloat = 10,
        safeAreaBottom: CGFloat = 0
    ) {
        self._selectedPage = selectedPage
        self.pageCount = pageCount
        self.height = height
        self.cornerRadius = cornerRadius
        self.spacing = spacing
        self.safeAreaBottom = safeAreaBottom
        self.indicatorView = { idx, isSelected in
            DefaultZikrPageIndicator(
                idx: idx,
                isSelected: isSelected,
                cornerRadius: cornerRadius
            )
        }
    }
}

struct DefaultZikrPageIndicator: View {
    @Environment(\.colorTheme) var colorTheme

    let idx: Int
    let isSelected: Bool
    var cornerRadius: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(isSelected ? colorTheme.getColor(.accent).opacity(0.5) : colorTheme.getColor(.contentBackground))
                .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)
            Text("\(idx + 1)")
                .font(.caption2)
                .foregroundColor(isSelected ? Color.white : colorTheme.getColor(.tertiaryText))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .minimumScaleFactor(0.15)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var selectedPage = 1
    PagesPreviewView(
        selectedPage: $selectedPage,
        pageCount: 5
    )
    .padding()
    .background(Color(.systemBackground))
}
