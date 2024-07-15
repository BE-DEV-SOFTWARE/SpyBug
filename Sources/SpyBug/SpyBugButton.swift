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
    @State private var isShowingReportOptionsView = false
    private var author: String?
    
    @ViewBuilder private var label: () -> Label
    
    public init(
        author: String?,
        @ViewBuilder label: @escaping () -> Label = { Text("Give some feedback") }
    ) {
        self.author = author
        self.label = label
    }
    
    public var body: some View {
        Button {
            isShowingReportOptionsView.toggle()
        } label: {
            label()
        }
        .adaptiveSheet(
            isPresented: $isShowingReportOptionsView,
            sheetBackground: Color(.background)
        ) {
            ReportOptionsView(
                author: author
            )
            .frame(height: 500)
        }
    }
}

#Preview("Button styling demo") {
    VStack {
        SpyBugButton(author: "") {
            Text("Click on me, I am custom 😉")
        }
        .buttonStyle(.borderedProminent)
        
        SpyBugButton(author: "")
        
        SpyBugButton(author: "") {
            Text("I can also look like this 😱")
        }
        .buttonStyle(
            ReportButtonStyle(
                icon: Image(systemName: "cursorarrow.rays")
            )
        )
    }
}

#Preview("Demo Dark") {
    SpyBugButton(author: "A nice person")
        .buttonStyle(.borderedProminent)
        .buttonStyle(
            ReportButtonStyle(
                icon: Image(systemName: "cursorarrow.rays")
            )
        )
        .preferredColorScheme(.dark)
}
#Preview("Demo Light") {
    SpyBugButton(author: "A nice person")
        .buttonStyle(.borderedProminent)
        .buttonStyle(
            ReportButtonStyle(
                icon: Image(systemName: "cursorarrow.rays")
            )
        )
        .preferredColorScheme(.light)
        .environment(\.locale, .init(identifier: "in"))
}
