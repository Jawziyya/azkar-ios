import SwiftUI
import Extensions

struct PagesPreviewView<Indicator: View>: View {
    @Environment(\.colorTheme) var colorTheme

    @Binding var selectedPage: Int

    let pageCount: Int
    var height: CGFloat = 56
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
                            .frame(maxHeight: height - 12)
                            .padding(.vertical, 6)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedPage = idx
                                    proxy.scrollTo(idx, anchor: .center)
                                    #if os(iOS)
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.prepare()
                                    generator.impactOccurred()
                                    #endif
                                }
                            }
                            .id(idx)
                    }
                }
                .padding(.horizontal, 18)
            }
            .frame(height: height)
            .onChange(of: selectedPage) { newPage in
                withAnimation(.easeInOut) {
                    proxy.scrollTo(newPage, anchor: .center)
                }
            }
        }
        .padding(.bottom, safeAreaBottom + 4)
        .padding(.horizontal, 0)
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var selectedPage = 1
    PagesPreviewView(
        selectedPage: $selectedPage,
        pageCount: 5,
        indicatorView: { idx, isSelected in
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)
                Text("Page \(idx + 1)")
                    .font(.caption)
                    .foregroundColor(isSelected ? Color.white : Color(.label))
            }
        }
    )
    .padding()
    .background(Color(.systemBackground))
}
