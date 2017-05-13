//
//  AnimationTimeline.swift
//  Anime
//
//  Created by Peng Wang on 05/11/2017.
//  Copyright (c) 2017 Peng Wang. All rights reserved.
//

import UIKit

public enum AnimationType {

    case plain(options: UIViewAnimationOptions)
    case keyframed(options: UIViewKeyframeAnimationOptions)
    case spring(options: UIViewAnimationOptions, damping: CGFloat, velocity: CGFloat)

}

public struct Animation {

    public var animations: () -> Void
    public var completion: ((Bool) -> Void)?
    public var delay: TimeInterval
    public var duration: TimeInterval
    public var type: AnimationType

    public init(
        animations: @escaping () -> Void = {},
        delay: TimeInterval = 0,
        duration: TimeInterval,
        type: AnimationType = .plain(options: []),
        completion: ((Bool) -> Void)? = nil) {
        self.animations = animations
        self.completion = completion
        self.delay = delay
        self.duration = duration
        self.type = type
    }

    public func with(
        animations: (() -> Void)? = nil,
        delay: TimeInterval? = nil,
        duration: TimeInterval? = nil,
        type: AnimationType? = nil,
        completion: ((Bool) -> Void)? = nil) -> Animation {
        var copy = self
        copy.animations = animations ?? copy.animations
        copy.delay = delay ?? copy.delay
        copy.duration = duration ?? copy.duration
        copy.type = type ?? copy.type
        copy.completion = completion ?? copy.completion
        return copy
    }

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
        case let .plain(options):
            UIView.animate(
                withDuration: a.duration,
                delay: a.delay,
                options: options,
                animations: a.animations,
                completion: completion
            )
        case let .keyframed(options):
            UIView.animateKeyframes(
                withDuration: a.duration,
                delay: a.delay,
                options: options,
                animations: a.animations,
                completion: completion
            )
        case let .spring(options, damping, velocity):
            UIView.animate(
                withDuration: a.duration,
                delay: a.delay,
                usingSpringWithDamping: damping,
                initialSpringVelocity: velocity,
                options: options,
                animations: a.animations,
                completion: completion
            )
        }
    }

}
