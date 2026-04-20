//
//  SwiftUIView.swift
//  SpyBug
//
//  Created by Pavel Kurzo on 21/01/2026.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
import AppKit

struct ClearHostingBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                HostingBackgroundClearer()
            }
    }
}

#if os(iOS) || os(visionOS)
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

#elseif os(macOS)

private struct HostingBackgroundClearer: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            view.superview?.layer?.backgroundColor = .clear
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

#endif

extension View {
    func clearHostingBackground() -> some View {
        modifier(ClearHostingBackground())
    }
}
