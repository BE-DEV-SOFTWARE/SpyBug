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
