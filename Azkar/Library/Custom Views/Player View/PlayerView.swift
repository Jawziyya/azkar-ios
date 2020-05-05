//
//  PlayerView.swift
//  mp3quran
//
//  Created by Abdurahim Jauzee on 31.10.2019.
//  Copyright © 2019 Jawziyya Ltd. All rights reserved.
//

import SwiftUI

struct PlayerView: View {

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
                .foregroundColor(.text)
                .font(Font.caption.monospacedDigit())
            Spacer()
            Button(action: {
                self.viewModel.play()
            }) {
                Image(systemName: "gobackward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 20)
            }
            Spacer()
            Button(action: {
                  self.viewModel.togglePlayPause()
            }) {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 25)
            }
            Spacer()
            Button(action: {
                  self.viewModel.toggleSpeed()
            }) {
                Text(viewModel.speed.label)
                    .frame(width: 30, height: 30)
                    .foregroundColor(tintColor)
                    .font(Font.body.monospacedDigit())
                    .minimumScaleFactor(0.5)
            }
            Spacer()
            Text(viewModel.timeRemaining)
                .foregroundColor(.text)
                .font(Font.caption.monospacedDigit())
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
        PlayerView(viewModel: PlayerViewModel(audioURL: Zikr.data[39].audioURL, player: .test))
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
