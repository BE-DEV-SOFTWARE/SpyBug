//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 21/06/2024.
//

import SwiftUI


public extension View {
    func reportOnShake(author: String?) -> some View {
        self.modifier(ReportOnShakeViewModifier(author: author))
    }
}

// UIWindow subclass to handle device shake
extension UIWindow {
    open override var canBecomeFirstResponder: Bool {
        true
    }
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

struct ReportOnShakeViewModifier: ViewModifier {
    let author: String?
    
    @State private var isShowingReportOptionsView = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIDevice.deviceDidShakeNotification, object: nil, queue: nil) { _ in
                    isShowingReportOptionsView.toggle()
                }
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

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name("deviceDidShakeNotification")
}
