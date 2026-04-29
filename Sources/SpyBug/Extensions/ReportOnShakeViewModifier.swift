//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 21/06/2024.
//

import SwiftUI
#if os(iOS)
import UIKit
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name("deviceDidShakeNotification")
}

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

struct ReportOnShakeViewModifier: ViewModifier {
    let author: String?
    let reportTypes: [ReportType]
    var isShakeAllowed: Binding<Bool>?
    
    @State private var isShowingReportOptionsView = false
    @State private var observer: NSObjectProtocol?
    
    private var shakeAllowed: Bool {
        let isGloballyDisabled = UserDefaults.standard.bool(forKey: "DisableReportOnShake")
        return (isShakeAllowed?.wrappedValue ?? true) && !isGloballyDisabled
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                observer = NotificationCenter.default.addObserver(
                    forName: UIDevice.deviceDidShakeNotification,
                    object: nil,
                    queue: .main
                ) { _ in
                    let isGloballyDisabled = UserDefaults.standard.bool(forKey: "DisableReportOnShake")
                    let allowed = (isShakeAllowed?.wrappedValue ?? true) && !isGloballyDisabled
                    if allowed {
                        isShowingReportOptionsView.toggle()
                    }
                }
            }
            .onDisappear {
                if let observer = observer {
                    NotificationCenter.default.removeObserver(observer)
                    self.observer = nil
                }
            }
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
    }
}

extension View {
    @ViewBuilder
    func conditionalPresentationCornerRadius(_ radius: CGFloat) -> some View {
        if #available(iOS 16.4, *) {
            self.presentationCornerRadius(radius)
        } else {
            self
        }
    }
}
#endif

#if os(iOS) && DEBUG
struct ReportOnShakePreviewView: View {
    @State private var isShakeAllowed = true
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Button("Simulate Shake") {
                NotificationCenter.default.post(
                    name: UIDevice.deviceDidShakeNotification,
                    object: nil
                )
            }
            .buttonStyle(.borderedProminent)
            
            Text("Shake device to report")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.background))
        .reportOnShake(
            author: "Preview User",
            reportTypes: ReportType.allCases,
            isShakeAllowed: $isShakeAllowed
        )
    }
}

#Preview("Report On Shake") {
    ReportOnShakePreviewView()
        .preferredColorScheme(.light)
}

#Preview("Report On Shake - Dark Mode") {
    ReportOnShakePreviewView()
        .preferredColorScheme(.dark)
}
#endif
