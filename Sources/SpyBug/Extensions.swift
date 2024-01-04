//
//  Extensions.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI

// for custom corner radius with stroke
@available(iOS 15.0, *)
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

@available(iOS 15.0, *)
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner, borderColor: Color? = nil, borderWidth: CGFloat? = nil) -> some View {
        overlay(
            RoundedCorner(radius: radius, corners: corners)
                .stroke(borderColor ?? Color.clear, lineWidth: borderWidth ?? 1)
        )
        .clipShape(
            RoundedCorner(radius: radius, corners: corners)
        )
    }
}

// just an extension for images for easy access
@available(iOS 15.0, *)
extension Image {
    static let bugRegular = Image("bugRegular")
    static let cameraImage = Image("cameraImage")
    static let circleQuestionRegular = Image("circleQuestionRegular")
    static let rocketLaunchRegular = Image("rocketLaunchRegular")
    static let wandMagicSparklesRegular = Image("wandMagicSparklesRegular")
    static let chevronRight = Image(systemName: "chevron.right")
}
