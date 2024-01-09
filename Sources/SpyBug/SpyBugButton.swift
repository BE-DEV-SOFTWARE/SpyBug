// SpyBugButton
//
// Created and maintained by Bereyziat Development
// Visit https://bereyziat.dev to contact us
// Or https://spybug.io to get an API key and get started
//
//

import SwiftUI
import SwiftUIAdaptiveActionSheet



@available(iOS 15.0, *)
public struct SpyBugButton<Label: View>: View {
    @State private var isShowingReportOptionsView = false
    
    private var apiKey: String
    private var author: String?
    
    @ViewBuilder private var label: () -> Label
        
    public init(
        apiKey: String,
        author: String?,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.apiKey = apiKey
        self.author = author
        self.label = label
    }
    
    public var body: some View {
        Button {
            isShowingReportOptionsView = true
        } label: {
            label()
        }
        .onShake {
            isShowingReportOptionsView.toggle()
        }
        .adaptiveHeightSheet(
            isPresented: $isShowingReportOptionsView
        ) {
            NavigationView {
                ReportOptionsView(
                    apiKey: apiKey,
                    author: author
                )
            }
            .frame(height: 450)
        }
    }
}

@available(iOS 15.0, *)
#Preview {
    VStack {
        SpyBugButton(apiKey: "", author: "") {
            Text("Click on me, I am custom 😉")
        }
        .buttonStyle(.borderedProminent)
        
        SpyBugButton(apiKey: "", author: "") {
            Text("I can also look like this 😱")
        }
        .buttonStyle(
            ReportButtonStyle(
                icon: Image(systemName: "cursorarrow.rays")
            )
        )
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension Image {
    init(packageResource name: String, ofType type: String) {
        #if canImport(UIKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: image)
        #elseif canImport(AppKit)
        guard let path = Bundle.module.path(forResource: name, ofType: type),
              let image = NSImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(nsImage: image)
        #else
        self.init(name)
        #endif
    }
}
