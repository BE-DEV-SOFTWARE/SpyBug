//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 18/07/2024.
//

#if os(iOS)
import UIKit
import Combine

final class KeyboardUtils {
    static func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

final class KeyboardResponder: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        let keyboardWillShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
        
        let keyboardWillHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
        
        Publishers.Merge(keyboardWillShow, keyboardWillHide)
            .receive(on: RunLoop.main)
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellableSet)
    }
}

typealias PlatformKeyboardResponder = KeyboardResponder
#endif
