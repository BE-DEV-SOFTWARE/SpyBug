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
    private var identifier: String
    
    @State private var isPresented: Bool
    @State private var shaked: Bool
    
    @ViewBuilder private var label: () -> Label
    
    @ObservedObject private var presentationManager = PresentationManager.shared
    
    public init(
        apiKey: String,
        author: String?,
        identifier: String,
        @ViewBuilder label: @escaping () -> Label = { Text("Give some feedback") }
    ) {
        self.apiKey = apiKey
        self.author = author
        self.identifier = identifier
        self._isPresented = State(initialValue: false)
        self._shaked = State(initialValue: false)
        self.label = label
        ShakeDetector.shared.startMonitoring()
    }
    
    public var body: some View {
        Button {
            presentSheet()
        } label: {
            label()
        }
        .adaptiveSheet(isPresented: $isPresented) {
            NavigationView {
                ReportOptionsView(
                    apiKey: apiKey,
                    author: author
                )
            }
            .frame(height: 450)
        }
        .onReceive(NotificationCenter.default.publisher(for: .shakeDetected)) { _ in
            handleShake()
        }
        .onChange(of: isPresented) { item in
            if !item {
                presentationManager.activeButtonIdentifier = nil
            }
        }
        .onChange(of: shaked) { _ in }
    }
    
    private func presentSheet() {
        if presentationManager.activeButtonIdentifier == nil {
            presentationManager.activeButtonIdentifier = identifier
            isPresented = true
        }
    }
    
    private func handleShake() {
        if presentationManager.activeButtonIdentifier == nil {
            presentationManager.activeButtonIdentifier = identifier
            isPresented = true
            shaked.toggle()
        }
    }
}

@available(iOS 15.0, *)
#Preview("Button styling demo") {
    VStack {
        SpyBugButton(apiKey: "", author: "", identifier: "id2") {
            Text("Click on me, I am custom 😉")
        }
        .buttonStyle(.borderedProminent)
        
        SpyBugButton(apiKey: "", author: "", identifier: "id3")
        
        SpyBugButton(apiKey: "", author: "", identifier: "id4") {
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
    SpyBugButton(apiKey: "", author: "A nice person", identifier: "id1")
       .buttonStyle(.borderedProminent)
       .buttonStyle(
           ReportButtonStyle(
               icon: Image(systemName: "cursorarrow.rays")
           )
       )
}
