//
//  AnimationTimeline.swift
//  Anime
//
//  Created by Peng Wang on 05/11/2017.
//  Copyright (c) 2017 Peng Wang. All rights reserved.
//

import UIKit

public enum AnimationType {

    case plain, keyframed, spring

}

public struct Animation {

    public var animations: () -> Void = {}
    public var completion: ((Bool) -> Void)?
    public var delay: TimeInterval = 0
    public var duration: TimeInterval = 0
    public var keyframeOptions: UIViewKeyframeAnimationOptions = []
    public var options: UIViewAnimationOptions = []
    public var spring: (damping: CGFloat, velocity: CGFloat) = (0.7, 1)
    public var type: AnimationType = .plain

    public init() {}

}

final public class AnimationTimeline {

    public var clearsOnFinish = true
    public var needsToCancel = false

    public var isEmpty: Bool { return animations.isEmpty }
    public private(set) var cursor: Int = 0

    private var animations = [Animation]()
    private var completion: (() -> Void)?

    public init() {}

    public func append(_ animations: Animation...) {
        self.animations.append(contentsOf: animations)
    }

    public func start(completion: (() -> Void)? = nil) {
        guard !animations.isEmpty else { return }
        guard self.completion == nil else { return }
        self.completion = completion
        step()
    }

    private func finish() {
        cursor = 0
        needsToCancel = false
        completion?()
        if clearsOnFinish {
            animations.removeAll()
        }
    }

    private func step() {
        let a = animations[cursor]
        let completion: (Bool) -> Void = { finished in
            a.completion?(finished)
            guard self.cursor + 1 < self.animations.count, !self.needsToCancel else {
                self.finish()
                return
            }
            self.cursor += 1
            self.step()
        }
        switch a.type {
        case .plain:
            UIView.animate(
                withDuration: a.duration,
                delay: a.delay,
                options: a.options,
                animations: a.animations,
                completion: completion
            )
        case .keyframed:
            UIView.animateKeyframes(
                withDuration: a.duration,
                delay: a.delay,
                options: a.keyframeOptions,
                animations: a.animations,
                completion: completion
            )
        case .spring:
            UIView.animate(
                withDuration: a.duration,
                delay: a.delay,
                usingSpringWithDamping: a.spring.damping,
                initialSpringVelocity: a.spring.velocity,
                options: a.options,
                animations: a.animations,
                completion: completion
            )
        }
    }

}
