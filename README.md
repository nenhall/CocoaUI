# CocoaUIKit
   > macOS UI控件定制

## Contents

- [Requirements](#requirements)
- [Migration Guides](#migration-guides)
- [Communication](#communication)
- [Installation](#installation)
- [Usage](#usage)
- [Credits](#credits)
- [License](#license)

## Requirements

- Mac OS X 10.14
- Xcode 11.0+
- Swift 5.0+

## Migration Guides

- [CocoaUIKit Migration Guide](Documentation/CocoaUIKit%203.0%20Migration%20Guide.md)

## Communication

- If you **need help**, use [cnblogs](https://www.cnblogs.com/nenhall/). (Tag 'CocoaUIKit')
- If you'd like to **ask a general question**, use [cnblogs](https://www.cnblogs.com/nenhall/).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.


## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate CocoaUIKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'CocoaUIKit', '~> 0.0.1'
end
```

Then, run the following command:

```bash
$ pod install
```

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

> Xcode 11+ is required to build CocoaUIKit using Swift Package Manager.

To integrate CocoaUIKit into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/nenhall/CocoaUIKit.git", .upToNextMajor(from: "0.0.1"))
]
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate CocoaUIKit into your project manually.

---

## Usage

### Quick Start

```swift
import CocoaUIKit

class MyViewController: UIViewController {

    lazy var cWindow: CoWindow = ...

    override func viewDidLoad() {
        super.viewDidLoad()

        cWindow.titlebarColor = .blue
    }

}
```

### Playground

You can try CocoaUIKit in Playground.

**Note:**

> To try CocoaUIKit, open `CocoaUIKit.xcworkspace` and build CocoaUIKit.framework for any simulator first.

### Resources

- [Documentation](https://www.cnblogs.com/nenhall)
- [F.A.Q.](https://www.cnblogs.com/nenhall)

## Credits

- Robert Payne ([@nenhall](https://www.cnblogs.com/nenhall))

## License

CocoaUIKit is released under the MIT license. See LICENSE for details.
