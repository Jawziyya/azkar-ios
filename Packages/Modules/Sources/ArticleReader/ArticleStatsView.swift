import SwiftUI

private extension Text {
    @ViewBuilder
    func applyNumericTransition(_ number: Double) -> some View {
        if #available(iOS 17.0, *) {
            self
                .contentTransition(.numericText(value: number))
        } else if #available(iOS 16.0, *) {
            self
                .contentTransition(.numericText())
        } else {
            self
        }
    }
}

struct ArticleStatsView: View {
    
    let abbreviatedNumber: String
    let number: Int
    let imageName: String
    @State var showNumber = false
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 15, height: 15)
            Text(abbreviatedNumber)
                .applyNumericTransition(Double(number))
        }
        .font(Font.caption)
        .onTapGesture {
            guard number.description != abbreviatedNumber else { return }
            withAnimation(.spring) {
                showNumber.toggle()
            }
        }
        .popover(
            present: $showNumber,
            view: {
                Text(number.description)
                    .frame(minWidth: 20)
                    .padding(4)
                    .foregroundStyle(Color.secondary)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .opacity(showNumber ? 1 : 0)
            }
        )
    }
}

private struct StatsViewPreview: View {
    @State var number = 1
    
    var body: some View {
        VStack {
            Button("Increment", action: {
                withAnimation(.spring) {
                    number += 5
                }
            })
            
            ArticleStatsView(
                abbreviatedNumber: number.description,
                number: number,
                imageName: "eye"
            )
        }
    }
}

#Preview {
    StatsViewPreview()
}
