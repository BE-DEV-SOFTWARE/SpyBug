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
#if os(visionOS)
    @Environment(\.supportsMultipleWindows) private var supportsMutlipleWindows
    @Environment(\.openWindow) private var openWindow
#endif
    private var author: String?
    private var reportTypes: [ReportType]
    private var id: String = "ReportOptionsView"
    
    @ViewBuilder private var label: () -> Label
    
    public init(
        author: String?,
        reportTypes: ReportType...,
        id: String = "ReportOptionsView",
        @ViewBuilder label: @escaping () -> Label = { Text("Give some feedback") }
        
    ) {
        self.author = author
        let resolvedReportTypes = reportTypes.isEmpty ? ReportType.allCases : reportTypes
        self.reportTypes = resolvedReportTypes
        self.id = id
        self.label = label
        
    }
    
    public var body: some View {
#if os(visionOS)
        Button {
            if #available(visionOS 1.1, *) {
                openWindow(id: id)
                print("Opening window")
            } else {
                isShowingReportOptionsView.toggle()
            }
        } label: {
            label()
        }
#endif
#if os(iOS)
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
                author: author,
                reportTypes: reportTypes
            )
            
            .frame(height: 500)
        }
        
        
        
        .onAppear {
            print("report types \(reportTypes)")
        }
#endif
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
        .environment(\.locale, .init(identifier: "en"))
}

