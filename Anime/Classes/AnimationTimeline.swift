//
//  AnimationTimeline.swift
//  Anime
//
//  Created by Peng Wang on 05/11/2017.
//  Copyright (c) 2017-18 Peng Wang. MIT license.
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
        of animations: @escaping () -> Void = {},
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
    private var completion: ((_ finished: Bool) -> Void)?

    public init() {}
    public convenience init(_ animations: Animation...) {
        self.init()
        append(animations)
    }

    public func append(_ animations: Animation...) {
        append(animations)
    }
    public func append(_ animations: [Animation]) {
        self.animations.append(contentsOf: animations)
    }

    @discardableResult public func start(completion: ((Bool) -> Void)? = nil) -> AnimationTimeline {
        guard !animations.isEmpty else { return self }
        self.completion = completion
        step()
        return self
    }

    private func finish() {
        cursor = 0
        let finished = cursor == animations.count - 1
        needsToCancel = false
        completion?(finished)
        if clearsOnFinish {
            completion = nil
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
