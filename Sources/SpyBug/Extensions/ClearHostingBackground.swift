//
//  SwiftUIView.swift
//  SpyBug
//
//  Created by Pavel Kurzo on 21/01/2026.
//

import SwiftUI

struct ClearHostingBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                HostingBackgroundClearer()
            )
    }
}

private struct HostingBackgroundClearer: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

extension View {
    func clearHostingBackground() -> some View {
        modifier(ClearHostingBackground())
    }
}
