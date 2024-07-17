//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 17/07/2024.
//

import SwiftUI
import Combine

class KeyboardUtils {
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

class KeyboardResponder: ObservableObject {
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
            .assign(to: \.isKeyboardVisible, on: self)
            .store(in: &cancellableSet)
    }
}
