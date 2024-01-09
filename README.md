# SpyBug
SpyBug is a SwiftUI package that offers a flexible bug picker component for Swift applications. It empowers users to upload images from their devices and include comments to describe specific bugs or suggested improvements. To get an API key please visit spybug.io and get started for free 🚀

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
2. Pass apiKey, author 
Author can be anything that let you identify the users of your project, a username, an email, an id. Author is an optional value so you can use SpyBug to make anonymous reports.

 SpyBugButton(apiKey: "123", author: "123")

## Example
For a quick start, you can use the provided ready-to-use examples or provide your own label to the SpyBugButton to adapt it to your project's Design System:
   ```swift
struct ContentView: View {
    var body: some View {
        VStack {
            SpyBugButton(apiKey: "123", author: "John Doe") {
                Text("Click me")
            }
            .buttonStyle(.bordered)
        }
        .padding()
```

![Simulator Screen Recording - iPhone 15 Pro - 2023-10-17 at 15 16 34](https://github.com/Bereyziat-Development/SpyBug/assets/72884798/1c58903e-fc7a-45fe-b81b-ad62eaa511d3) 



## License
This library is available under the MIT license. See the [LICENSE](LICENSE) file for more information.

---
