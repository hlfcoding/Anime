# Anime

[![Version](https://img.shields.io/cocoapods/v/Anime.svg?style=flat)](http://cocoapods.org/pods/Anime)
[![License](https://img.shields.io/cocoapods/l/Anime.svg?style=flat)](http://cocoapods.org/pods/Anime)
[![Platform](https://img.shields.io/cocoapods/p/Anime.svg?style=flat)](http://cocoapods.org/pods/Anime)

> :film_strip: &nbsp; UIView animation from the Far East.

![anime](https://cloud.githubusercontent.com/assets/100884/25989526/5c303b94-36b1-11e7-90d6-610694124c1d.gif)

## Example

```swift
let timeline = AnimationTimeline()
var a = Animation()
a.duration = 1
a.animations = { /* ... */ }
var b = a
b.animations = { /* ... */ }
timeline.append(a, b)
// ...
timeline.start() {
  print("done")
}
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift 3+

## Installation

Anime is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Anime"
```

## Author

Peng Wang, peng@pengxwang.com

## License

Anime is available under the MIT license. See the LICENSE file for more info.
