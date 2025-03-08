import SwiftUI
import Library

struct PlayerView: View, Equatable {

    static func == (lhs: PlayerView, rhs: PlayerView) -> Bool {
        return lhs.viewModel == rhs.viewModel
    }

    @ObservedObject var viewModel: PlayerViewModel
    @Environment(\.colorTheme) var colorTheme
    
    var tintColor: Color {
        colorTheme.getColor(.accent)
    }
    var progressBarColor: Color {
        colorTheme.getColor(.accent, opacity: 0.1)
    }
    var progressBarHeight: CGFloat = 1

    var body: some View {
        VStack(spacing: 8) {
            buttonsView
                .foregroundStyle(tintColor)
            progressBar
        }
    }

    private var buttonsView: some View {
        HStack(alignment: .center) {
            Text(viewModel.timeElapsed)
                .foregroundStyle(.tertiaryText)
                .font(Font.system(.caption, design: .monospaced))
            Spacer()
            Button(action: {
                self.viewModel.play()
            }, label: {
                Image(systemName: "gobackward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 20)
            })
            Spacer()
            Button(action: {
                self.viewModel.togglePlayPause()
            }, label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 25)
            })
            Spacer()
            Button(action: {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 0.6)
                self.viewModel.toggleSpeed()
            }, label: {
                Text(viewModel.speed.label)
                    .minimumScaleFactor(0.2)
                    .frame(width: 30, height: 30)
                    .foregroundStyle(tintColor)
                    .font(Font.system(.body, design: .monospaced))
                    .minimumScaleFactor(0.5)
            })
            Spacer()
            Text(viewModel.timeRemaining)
                .foregroundStyle(.tertiaryText)
                .font(Font.system(.caption, design: .monospaced))
        }
        .padding(.horizontal)
    }

    private var progressBar: some View {
        ProgressBar(value: viewModel.progress, maxValue: 1, backgroundColor: progressBarColor, foregroundStyle: tintColor)
        .frame(height: progressBarHeight)
    }

}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(viewModel: PlayerViewModel(
            title: "",
            subtitle: "",
            audioURL: URL(string: "https://google.com")!,
            timings: [],
            player: .test
        ))
        .previewDevice(.init(stringLiteral: "iPhone 11 Pro"))
        .environment(\.sizeCategory, .accessibilityLarge)
        .background(.background)
        .environment(\.colorScheme, .dark)
    }
}
