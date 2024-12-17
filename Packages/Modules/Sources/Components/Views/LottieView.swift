import SwiftUI
import Lottie
import Library

public struct LottieView: UIViewRepresentable {
    
    public typealias UIViewType = UIView
    
    let animationView = LottieAnimationView()
    let name: String
    var loopMode: LottieLoopMode = .playOnce
    var contentMode: UIView.ContentMode = .scaleAspectFit
    var speed: CGFloat = 1
    var progress: CGFloat?
    var completionBlock: Action?
    
    public init(
        name: String,
        loopMode: LottieLoopMode,
        contentMode: UIView.ContentMode,
        speed: CGFloat,
        progress: CGFloat? = nil,
        completionBlock: Action? = nil
    ) {
        self.name = name
        self.loopMode = loopMode
        self.contentMode = contentMode
        self.speed = speed
        self.progress = progress
        self.completionBlock = completionBlock
    }
    
    public class Coordinator {
        var colorScheme: ColorScheme?
        var completionBlock: Action?
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    public func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        context.coordinator.colorScheme = context.environment.colorScheme
        context.coordinator.completionBlock = completionBlock
        animationView.animation = LottieAnimation.named(name)
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.animationSpeed = speed
        if let progress = progress {
            animationView.currentProgress = progress
        }
        if progress != 1 {
            animationView.play { finished in
                guard finished else { return }
                context.coordinator.completionBlock?()
            }
        }
        animationView.isUserInteractionEnabled = false
        
        let view = UIView()
        view.addSubview(animationView)
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        guard context.coordinator.colorScheme != context.environment.colorScheme else {
            return
        }
        context.coordinator.colorScheme = context.environment.colorScheme
        DispatchQueue.main.async {
            if let view = uiView.subviews.first(where: { $0 is LottieAnimationView }) as? LottieAnimationView {
                view.stop()
                view.animation = LottieAnimation.named(name)
                view.play()
            }
        }
    }

}
