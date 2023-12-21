// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI
import SwiftUIAdaptiveActionSheet
import UIKit

// button styly optional to pass, default to normal button
// api key to pass
// author id to pass
// show the sheet when shaking the phone

@available(iOS 15.0, *)
public struct SpyBug: View {
    @State private var isShowingReportOptionsView = false
    
    var apiKey: String = ""
    var authorId: String = ""
    var buttonStyle: any ButtonStyle
    
    public init(
        isShowingReportOptionsView: Bool = false,
        apiKey: String = "",
        authorId: String = "",
        buttonStyle: any ButtonStyle = ReportBugButtonStyle.defaultStyle
    ) {
        self.apiKey = apiKey
        self.authorId = authorId
        self.buttonStyle = buttonStyle
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
            .buttonStyle(ReportBugButtonStyle())
        }
        .adaptiveHeightSheet(isPresented: $isShowingReportOptionsView) {
            NavigationView {
                ReportOptionsView()
            }
            .frame(height: 450)
        }
    }
}

@available(iOS 15.0, *)
#Preview {
    SpyBug()
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
