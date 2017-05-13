//
//  ViewController.swift
//  Anime
//
//  Created by Peng Wang on 05/11/2017.
//  Copyright (c) 2017 Peng Wang. All rights reserved.
//

import UIKit
import Anime

class ViewController: UIViewController {

    var timeline: AnimationTimeline!

    var box: UIButton!
    var distanceToCenter: CGPoint!

    lazy var baseAnimation: Animation = {
        return Animation(delay: 0.2, duration: 0.4) { [unowned self] _ in
            NSLog("\(self.timeline.cursor)")
        }
    }()

    lazy var downAnimation: Animation = {
        return self.baseAnimation.with(animations: { [unowned self] _ in
            self.box.transform = self.box.transform.translatedBy(x: 0, y: self.distanceToCenter.y)
        }, type: .spring(options: [], damping: 0.7, velocity: 1))
    }()

    lazy var leftAnimation: Animation = {
        return self.baseAnimation.with(animations: { [unowned self] _ in
            let oldColor = self.box.backgroundColor
            let oldTransform = self.box.transform
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.box.backgroundColor = UIColor.red
                self.box.transform = self.box.transform.scaledBy(x: 2, y: 2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.box.backgroundColor = oldColor
                self.box.transform = oldTransform.translatedBy(x: -self.distanceToCenter.x, y: 0)
            }
        }, type: .keyframed(options: []))
    }()

    lazy var rightAnimation: Animation = {
        return self.baseAnimation.with(animations: { [unowned self] _ in
            self.box.transform = self.box.transform.translatedBy(x: self.distanceToCenter.x, y: 0)
        })
    }()

    lazy var upAnimation: Animation = {
        return self.baseAnimation.with(animations: { [unowned self] _ in
            self.box.transform = self.box.transform.translatedBy(x: 0, y: -self.distanceToCenter.y)
        })
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        box = UIButton(type: .custom)
        box.alpha = 0
        box.backgroundColor = UIColor.white
        box.addTarget(self, action: #selector(animateBox(_:)), for: .touchUpInside)
        view.addSubview(box)

        let d = ceil(view.frame.width / 3)
        box.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: d, height: d)
        box.translatesAutoresizingMaskIntoConstraints = false
        distanceToCenter = CGPoint(
            x: view.bounds.midX - box.frame.midX,
            y: view.bounds.midY - box.frame.midY
        )

        timeline = AnimationTimeline()
    }

    override func viewDidAppear(_ animated: Bool) {
        if box.alpha == 0 {
            UIView.animate(withDuration: 0.3) { self.box.alpha = 1 }
        }
    }

    @objc private func animateBox(_ sender: UIButton) {
        guard timeline.isEmpty else { return }
        timeline.append(
            rightAnimation, rightAnimation, downAnimation, downAnimation, leftAnimation,
            upAnimation, downAnimation, leftAnimation, upAnimation, upAnimation
        )
        timeline.start()
    }

}
