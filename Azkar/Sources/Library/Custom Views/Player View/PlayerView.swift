//
//  PlayerView.swift
//  mp3quran
//
//  Created by Abdurahim Jauzee on 31.10.2019.
//  Copyright © 2019 Jawziyya Ltd. All rights reserved.
//

import SwiftUI

struct PlayerView: View, Equatable {

    static func == (lhs: PlayerView, rhs: PlayerView) -> Bool {
        return lhs.viewModel == rhs.viewModel
    }

    @ObservedObject var viewModel: PlayerViewModel
    
    var tintColor: Color = .accent
    var progressBarColor: Color = Color.accent.opacity(0.3)
    var progressBarHeight: CGFloat = 1

    var body: some View {
        VStack(spacing: 8) {
            buttonsView
                .foregroundColor(tintColor)
            progressBar
        }
    }

    private var buttonsView: some View {
        HStack(alignment: .center) {
            Text(viewModel.timeElapsed)
                .foregroundColor(.tertiaryText)
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
                    .foregroundColor(tintColor)
                    .font(Font.system(.body, design: .monospaced))
                    .minimumScaleFactor(0.5)
            })
            Spacer()
            Text(viewModel.timeRemaining)
                .foregroundColor(.tertiaryText)
                .font(Font.system(.caption, design: .monospaced))
        }
        .padding(.horizontal)
    }

    private var progressBar: some View {
        ProgressBar(value: viewModel.progress, maxValue: 1, backgroundColor: progressBarColor, foregroundColor: tintColor)
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
        .background(Color.background)
        .environment(\.colorScheme, .dark)
    }
}
