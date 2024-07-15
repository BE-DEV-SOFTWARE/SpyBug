//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 21/06/2024.
//

import SwiftUI

class PresentationManager: ObservableObject {
    static let shared = PresentationManager()
    
    @Published var activeButtonIdentifier: String?
    
    private init() {}
}

class ShakeDetector: ObservableObject {
    static let shared = ShakeDetector()
    
    private init() { }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidShake), name: UIDevice.deviceDidShakeNotification, object: nil)
    }
    
    @objc private func deviceDidShake() {
        NotificationCenter.default.post(name: .shakeDetected, object: nil)
    }
}

extension Notification.Name {
    static let shakeDetected = Notification.Name("shakeDetected")
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

struct DeviceShakeViewModifier: ViewModifier {
    let identifier: String
    let action: () -> Void
    
    @State private var activeIdentifier: String?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIDevice.deviceDidShakeNotification, object: nil, queue: nil) { _ in
                    if activeIdentifier == nil {
                        activeIdentifier = identifier
                        self.action()
                    }
                }
            }
            .onDisappear {
                activeIdentifier = nil
            }
    }
}

extension View {
    func onShake(identifier: String, perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(identifier: identifier, action: action))
    }
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name("deviceDidShakeNotification")
}

