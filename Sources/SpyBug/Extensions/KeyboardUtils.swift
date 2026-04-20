//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 18/07/2024.
//

#if os(iOS)
import UIKit
#endif

import Combine
#if canImport(AppKit)
import AppKit
#endif

class KeyboardUtils {
    static func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #elseif canImport(AppKit)
        NSApp.keyWindow?.makeFirstResponder(nil)
        #endif
    }
}

class KeyboardResponder: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        #if canImport(UIKit)
        let keyboardWillShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
        
        let keyboardWillHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
        
        Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellableSet)
        #elseif canImport(AppKit)
        setupMacOSKeyboardNotifications()
        #endif
    }
    
    #if canImport(AppKit)
    private func setupMacOSKeyboardNotifications() {
        NotificationCenter.default
            .publisher(for: NSWindow.didBecomeKeyNotification)
            .sink { [weak self] _ in
                self?.isKeyboardVisible = false
            }
            .store(in: &cancellableSet)
    }
    #endif
}

#if canImport(AppKit)
class MacKeyboardResponder: ObservableObject {
    @Published var isTextFieldEditing: Bool = false
    private var notificationObservers: [NSObjectProtocol] = []
    
    init() {
        notificationObservers.append(
            NotificationCenter.default.addObserver(
                forName: NSText.didBeginEditingNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.isTextFieldEditing = true
            }
        )
        
        notificationObservers.append(
            NotificationCenter.default.addObserver(
                forName: NSText.didEndEditingNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.isTextFieldEditing = false
            }
        )
    }
    
    deinit {
        notificationObservers.forEach { NotificationCenter.default.removeObserver($0) }
    }
}
#endif

#if canImport(UIKit)
typealias PlatformKeyboardResponder = KeyboardResponder
#elseif canImport(AppKit)
typealias PlatformKeyboardResponder = MacKeyboardResponder
#endif
