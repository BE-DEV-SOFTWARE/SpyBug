// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI
import SwiftUIAdaptiveActionSheet
import UIKit


@available(iOS 15.0, *)
public struct SpyBug: View {
    @State private var isShowingReportOptionsView = false
    
    var apiKey: String
    var authorId: String?
    var useCustomButtonStyle: Bool = false
        
    public init(
        apiKey: String,
        authorId: String?,
        useCustomButtonStyle: Bool = false
    ) {
        self.apiKey = apiKey
        self.authorId = authorId
        self.useCustomButtonStyle = useCustomButtonStyle
    }
    
    public var body: some View {
        VStack {
            Button {
                isShowingReportOptionsView = true
            } label: {
                HStack(spacing: 16) {
                    Image(packageResource: "bug-regular", ofType: "png")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black.opacity(0.6))
                    
                    Text("Report a bug")
                        .foregroundStyle(Color.black.opacity(0.8))
                        .font(.system(size: 18))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 12, height: 21)
                        .foregroundStyle(.black.opacity(0.6))
                        .padding(.trailing)
                }
            }
        }
        .if(!useCustomButtonStyle) {
            $0.buttonStyle(ReportBugButtonStyle.defaultStyle)
        }
        .onShake(perform: {
            isShowingReportOptionsView.toggle()
        })
        .adaptiveHeightSheet(isPresented: $isShowingReportOptionsView) {
            NavigationView {
                ReportOptionsView(apiKey: apiKey)
            }
            .frame(height: 450)
        }
    }
}

@available(iOS 15.0, *)
#Preview {
    SpyBug(apiKey: "", authorId: "")
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
