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

    @State private var isSheetPresented: Bool = false

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
            isSheetPresented = true
        } label: {
            label()
        }
        .adaptiveSheet(
            isPresented: $isSheetPresented,
            onDismiss: {
                isSheetPresented = false
                spyBug.isPresented = false // Ensure global state is updated
            }) {
            NavigationView {
                ReportOptionsView(
                    apiKey: apiKey,
                    author: author
                )
            }
            .frame(height: 450)
        }
        .onAppear {
            // Sync state if already presented via shake
            isSheetPresented = spyBug.isPresented
        }
        .onChange(of: spyBug.isPresented) { newValue in
            isSheetPresented = newValue
        }
    }
}
