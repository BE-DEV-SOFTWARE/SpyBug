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
    private var reportTypes: [ReportType]
    private let configurationManager = ReportTypeConfigurationManager()
    
    @ViewBuilder private var label: () -> Label
    
    public init(
        author: String?,
        reportTypes: ReportType...,
        @ViewBuilder label: @escaping () -> Label = { Text("Give some feedback") }
    ) {
        self.author = author
        let resolvedReportTypes = reportTypes.isEmpty ? ReportType.allCases : reportTypes
        self.reportTypes = resolvedReportTypes
        self.label = label
        configurationManager.saveSelectedReportTypes(resolvedReportTypes)
    }
    
    public var body: some View {
        Button {
            isShowingReportOptionsView.toggle()
        } label: {
            label()
        }
#if os(iOS)
        .adaptiveSheet(
            isPresented: $isShowingReportOptionsView,
            sheetBackground: Color(.background)
        ) {
            ReportOptionsView(
                author: author,
                reportTypes: configurationManager.loadSelectedReportTypes()
            )
            
            .frame(height: 500)
        }
        
#endif
#if os(visionOS)
        .popover(isPresented: $isShowingReportOptionsView,
                 arrowEdge: .top,
                 content: {
            NavigationView{
                ReportOptionsView(
                    author: author,
                    reportTypes: configurationManager.loadSelectedReportTypes()
                )}
            .frame(width: 400, height: 650)
            .navigationBarBackButtonHidden(false)
            
            .background(Color("Background"))
        })
#endif
        .onAppear {
            print("report types \(reportTypes)")
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
        .environment(\.locale, .init(identifier: "en"))
}
