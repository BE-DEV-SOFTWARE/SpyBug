// SpyBugButton
//
// Created and maintained by Bereyziat Development
// Visit https://bereyziat.dev to contact us
// Or https://spybug.io to get an API key and get started
//
//

import SwiftUI
import AdaptiveSheet


@available(iOS 15.0, *)
public struct SpyBugButton<Label: View>: View {
    private var apiKey: String
    private var author: String?
    @ObservedObject private var spyBug = SpyBug.shared

    
    @ViewBuilder private var label: () -> Label
        
    public init(
        apiKey: String,
        author: String?,
        @ViewBuilder label: @escaping () -> Label = { Text("Give some feedback") }
    ) {
        self.apiKey = apiKey
        self.author = author
        self.label = label
    }
    
    public var body: some View {
        Button {
            spyBug.isPresented.toggle()
        } label: {
            label()
        }
        .adaptiveSheet(
            isPresented: $spyBug.isPresented
            , onDismiss: {
                spyBug.isPresented = false
            }) {
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
#Preview("Button styling demo") {
    VStack {
        SpyBugButton(apiKey: "", author: "") {
            Text("Click on me, I am custom 😉")
        }
        .buttonStyle(.borderedProminent)
        
        SpyBugButton(apiKey: "", author: "")
        
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

#Preview("Demo") {
    SpyBugButton(apiKey: "", author: "A nice person")
       .buttonStyle(.borderedProminent)
       .buttonStyle(
           ReportButtonStyle(
               icon: Image(systemName: "cursorarrow.rays")
           )
       )
}
