# SpyBug
SpyBug is a SwiftUI package that offers a flexible bug/feedback collection component for Swift applications. It empowers users to upload images from their devices and include comments to describe specific bugs or suggested improvements. To get an API key you can create your account on [app.spybug.io](https://app.spybug.io) and get started for free 🚀

## Requirements
iOS 15 or later
Swift 5.5 or later

## Installation
### Swift Package Manager
You can easily integrate SpyBug using the Swift Package Manager. Follow these simple steps:

1. Open your project in Xcode.
2. Navigate to File > Swift Packages > Add Package Dependency.
3. Enter the package repository URL: https://github.com/Bereyziat-Development/SpyBug
4. Click Next and follow the remaining steps to add the package to your project.

## Usage
1. Import SpyBug:

```swift
import SpyBug
```

2. Configure SpyBug API key for your application

Simply add a new key "SpyBugAPIKey" to your Info.plist configuration file and you are good to go. To get a key go to your [SpyBug admin panel](https://app.spybug.io) create a new application and copy the provided API key

3. Now you can add as many SpyBugButton as you want to your application.
The "author" attribute can be anything that let you identify the users of your project, a username, an email, an id. Author is an optional value so you can use SpyBug to make anonymous reports.

```swift
 SpyBugButton(author: "AnonymousPlatypus") { <Insert your custom label here> } 
```

4. You don't like buttons? Then you can simply activate the feature to report on shake. (Also really suitable for users with anger issues). Add the view modifier to your main app file or to the page you want the shake feature to be available.

```swift
.reportOnShake(author: "your_optional_author_name")
```

### Using Default Button Style

```swift
    SpyBugButton(author: "your_optional_author_name") {
        Text("Click on me, I am custom 😉")
    }
    .buttonStyle(.borderedProminent)
```

### Using Custom Button Style
```swift
    SpyBugButton(author: "") {
        Text("I can also look like this 😱")
    }
    .buttonStyle(
        ReportButtonStyle(
            icon: Image(systemName: "cursorarrow.rays")
        )
    )
```

## VisionOS
To run SpyBug on VisionOS app, you need to add the ReportWindow that contains the reporting UI. 


In you main AppFile add:
```swift
 ReportWindow()
```
In your info.plist don't forget to set the "Enable Multiple Windows" key to "YES" to enable you app to show multiple windows

To place your ReportWindow in a specific place, for example near your main UI you can use this modifier:
```swift
.defaultWindowPlacement { _, context in
    if let relativeWindow = context.windows.first(where: { $0.id == "relativeWindowId" }) {
        return WindowPlacement(.trailing(relativeWindow))
    } else {
        return WindowPlacement()
    }
}

```

https://github.com/user-attachments/assets/2d71cf88-3ed0-46b5-82cc-1d11d8d02c19


## License
This library is available under the MIT license. See the [LICENSE](LICENSE) file for more information.

---
