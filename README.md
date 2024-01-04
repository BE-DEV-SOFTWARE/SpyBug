# SpyBug
SpyBug is a SwiftUI package that offers a flexible bug picker component for Swift applications. It empowers users to upload images from their devices and include comments to describe specific bugs or suggested improvements.

## Requirements
iOS 15 or later
Swift 5.5 or later

## Installation
### Swift Package Manager
You can easily integrate SpyBug using the Swift Package Manager. Follow these simple steps:

Open your project in Xcode.
Navigate to File > Swift Packages > Add Package Dependency.
Enter the package repository URL: https://github.com/Bereyziat-Development/SpyBug
Click Next and follow the remaining steps to add the package to your project.

## Usage
1. Import the necessary modules:

```swift
import SwiftUI
import SpyBug
```
2. Pass apiKey, authorId, useCustomButtonStyle

 SpyBug(apiKey: "123", authorId: "123", useCustomButtonStyle: false)

## Example
For a quick start, you can use the provided ready-to-use example:
   ```swift
struct ContentView: View {
    var body: some View {
        VStack {
            SpyBug(apiKey: "123", authorId: "123", useCustomButtonStyle: false)
        }
        .padding()

  or if you want to use CustomButtonStyle you should go with this

 VStack {
            SpyBug(apiKey: "123", authorId: "123", useCustomButtonStyle: true)
        }
        .buttonStyle(.bordered)
        .padding()
    }
```

![Simulator Screen Recording - iPhone 15 Pro - 2023-10-17 at 15 16 34](https://github.com/Bereyziat-Development/SpyBug/assets/72884798/1c58903e-fc7a-45fe-b81b-ad62eaa511d3) 



## License
This library is available under the MIT license. See the [LICENSE](LICENSE) file for more information.

---
