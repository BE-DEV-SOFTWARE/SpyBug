//
//  ReportButtonView.swift
//  
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI
import SwiftUIAdaptiveActionSheet 
import SnapPix
import UIKit

@available(iOS 15.0, *)
struct ReportButtonView: View {
    @State private var isShowingReportOptionsView = false
    
    var body: some View {
        VStack {
            Button {
                isShowingReportOptionsView = true
            } label: {
                Text("Report a bug")
                    .foregroundStyle(Color.black.opacity(0.8))
            }
            Image(packageResource: "apple", ofType: "png")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.red)
                .frame(width: 50, height: 50)
        }
        .sheet(isPresented: $isShowingReportOptionsView) {
            ReportOptionsView()
        }
                .adaptiveHeightSheet(isPresented: $isShowingReportOptionsView) {
                    ReportOptionsView()
                }
    }
}

@available(iOS 15.0, *)
#Preview {
    ReportButtonView()
}

//@available(iOS 15.0, *)
//extension Image {
//    static var buugRegular: Image {
//        Image("Test", bundle: .main)
//    }
//    
//    static var anotherImage: Image {
//        Image("anotherImage", bundle: .main)
//    }
//}

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
