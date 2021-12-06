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
    
    typealias UIViewType = UIView
    
    let animationView = AnimationView()
    let name: String
    var loopMode: LottieLoopMode = .playOnce
    var contentMode: UIView.ContentMode = .scaleAspectFit
    var speed: CGFloat = 1
    
    class Coordinator {
        var colorScheme: ColorScheme?
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        context.coordinator.colorScheme = context.environment.colorScheme
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
        guard context.coordinator.colorScheme != context.environment.colorScheme else {
            return
        }
        context.coordinator.colorScheme = context.environment.colorScheme
        DispatchQueue.main.async {
            if let view = uiView.subviews.first(where: { $0 is AnimationView }) as? AnimationView {
                view.stop()
                view.animation = Animation.named(name)
                view.play()
            }
        }
    }

}
