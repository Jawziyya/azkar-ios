import SwiftUI

struct CollapsableView<Header: View, Content: View>: View {

    @Binding var isExpanded: Bool
    @ViewBuilder let header: () -> Header
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: isExpanded ? 10 : 0) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                isExpanded.toggle()
            }, label: {
                header()
            })
            .buttonStyle(BorderlessButtonStyle())
            .zIndex(1)

            ZStack {
                if isExpanded {
                    Group {
                        content()
                    }
                    .clipped()
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .zIndex(0)
        }
        .clipped()
    }

}

struct CollapsableView_Previews: PreviewProvider {
    static var previews: some View {
        let zikr = Zikr.placeholder
        Stateful(initialState: false) { isExpanded in
            CollapsableView(
                isExpanded: isExpanded,
                header: {
                    Text("Test")
                },
                content: {
                    Text(zikr.text)
                }
            )
        }
        .previewLayout(.fixed(width: 350, height: 200))
    }
}
