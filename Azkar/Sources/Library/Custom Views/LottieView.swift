//
//
//  Azkar
//
//  Created on 20.08.2021
//
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {

    let animationView = AnimationView()
    let name: String
    var loopMode: LottieLoopMode = .playOnce
    var contentMode: UIView.ContentMode = .scaleAspectFit
    var speed: CGFloat = 1

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        animationView.animation = Animation.named(name)
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = speed
        animationView.play()
        animationView.isUserInteractionEnabled = false

        let view = UIView()
        view.addSubview(animationView)
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        DispatchQueue.main.async {
            if let view = uiView.subviews.first(where: { $0 is AnimationView }) as? AnimationView {
                view.stop()
                view.animation = Animation.named(name)
                view.play()
            }
        }
    }

}
