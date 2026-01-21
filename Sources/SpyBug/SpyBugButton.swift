// SpyBugButton
//
// Created and maintained by Bereyziat Development
// Visit https://bereyziat.dev to contact us
// Or https://spybug.io to get an API key and get started
//
//

import SwiftUI

@available(iOS 15.0, *)
public struct SpyBugButton<Label: View>: View {
    @State private var isShowingReportOptionsView = false
#if os(visionOS)
    @Environment(\.openWindow) private var openWindow
#endif
    private var author: String?
    private var reportTypes: [ReportType]
    @ViewBuilder private var label: () -> Label

    public init(
        author: String?,
        reportTypes: [ReportType] = ReportType.allCases,
        @ViewBuilder label: @escaping () -> Label = { Text("Give some feedback") }
    ) {
        self.author = author
        self.reportTypes = reportTypes
        self.label = label
    }
    
    public var body: some View {
        Button {
            print("Button is clicked 👾")
            openReportDialog()
        } label: {
            label()
        }
#if os(iOS)
        .sheet(isPresented: $isShowingReportOptionsView) {
            NavigationStack {
                ZStack {
                    if #available(iOS 26.0, *) {
                        //
                    } else {
                        Color(.background)
                            .edgesIgnoringSafeArea(.all)
                    }
                    
                    ReportOptionsView(
                        author: author,
                        reportTypes: reportTypes
                    )
                    .frame(height: 500)
                }
            }
            .presentationDetents([.height(530)])
            .conditionalPresentationCornerRadius(24)
        }
#endif
    }
    
    private func openReportDialog() {
#if os(visionOS)
    openWindow(id: Constant.reportWindowId)
#elseif os(iOS)
    isShowingReportOptionsView.toggle()
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
