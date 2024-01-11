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

```swift
 SpyBugButton(apiKey: "", author: "") { Your Label } 
   ```

### Using Default Button Style

```swift

SpyBugButton(apiKey: "your_api_key", author: "your_author_name") {
    Text("Click on me, I am custom 😉")
}
.buttonStyle(.borderedProminent)

```
### Using Custom Button Style
```swift
        SpyBugButton(apiKey: "", author: "") {
            Text("I can also look like this 😱")
        }
        .buttonStyle(
            ReportButtonStyle(
                icon: Image(systemName: "cursorarrow.rays")
            )
        )

![Simulator Screen Recording - iPhone 15 Pro - 2023-10-17 at 15 16 34](https://github.com/Bereyziat-Development/SpyBug/assets/72884798/20dfed3a-914a-4782-82d9-05a10d86e3e3)

## License
This library is available under the MIT license. See the [LICENSE](LICENSE) file for more information.

---
