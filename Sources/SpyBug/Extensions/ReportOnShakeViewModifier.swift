//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 21/06/2024.
//

import SwiftUI


public extension View {
    func reportOnShake(author: String?, reportTypes: [ReportType] = ReportType.allCases, isShakeAllowed: Binding<Bool>? = nil) -> some View {
        self.modifier(ReportOnShakeViewModifier(author: author, reportTypes: reportTypes, isShakeAllowed: isShakeAllowed))
    }
}

public extension View {
    func disableReportOnShake() -> some View {
        self.onAppear {
            UserDefaults.standard.set(true, forKey: "DisableReportOnShake")
        }
        .onDisappear {
            UserDefaults.standard.set(false, forKey: "DisableReportOnShake")
        }
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
    let reportTypes: [ReportType]
    var isShakeAllowed: Binding<Bool>?
    
    @State private var isShowingReportOptionsView = false
    
    private var shakeAllowed: Bool {
         let isGloballyDisabled = UserDefaults.standard.bool(forKey: "DisableReportOnShake")
         return isShakeAllowed?.wrappedValue ?? true && !isGloballyDisabled
     }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIDevice.deviceDidShakeNotification, object: nil, queue: nil) { _ in
                    if shakeAllowed {
                        isShowingReportOptionsView.toggle()
                    }
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self, name: UIDevice.deviceDidShakeNotification, object: nil)
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
    }
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name("deviceDidShakeNotification")
}
