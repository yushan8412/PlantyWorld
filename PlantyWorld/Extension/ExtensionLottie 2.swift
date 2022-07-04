//
//  ExtensionLottie.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/3.
//

import Foundation
import Lottie

extension UIViewController {
    
    func loadAnimation(name: String, loopMode: LottieLoopMode) -> AnimationView {
        let animationView = AnimationView(name: name)
        let width = self.view.frame.width
        animationView.frame = CGRect(x: 0, y: 0, width: width, height: 200)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        view.addSubview(animationView)
        animationView.loopMode = loopMode
        
        return animationView
    }
    
    func generateAnimationView(name: String, loopMode: LottieLoopMode) -> AnimationView {
        let animationView = AnimationView(name: name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        return animationView
    }
}
