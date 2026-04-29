//
//  CornerRadius.swift
//
//
//  Created by Jonathan Bereyziat on 09/01/2024.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(UIKit)
typealias PlatformRectCorner = UIRectCorner
#elseif canImport(AppKit)
import AppKit

struct PlatformRectCorner: OptionSet {
    let rawValue: Int
    
    static let topLeft = PlatformRectCorner(rawValue: 1 << 0)
    static let topRight = PlatformRectCorner(rawValue: 1 << 1)
    static let bottomLeft = PlatformRectCorner(rawValue: 1 << 2)
    static let bottomRight = PlatformRectCorner(rawValue: 1 << 3)
    static let allCorners: PlatformRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}
#endif

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    #if canImport(UIKit)
    var corners: UIRectCorner = .allCorners
    #elseif canImport(AppKit)
    var corners: PlatformRectCorner = .allCorners
    #endif
    
    func path(in rect: CGRect) -> Path {
        #if canImport(UIKit)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
        #elseif canImport(AppKit)
        var path = Path()
        
        let topLeft = corners.contains(.topLeft)
        let topRight = corners.contains(.topRight)
        let bottomLeft = corners.contains(.bottomLeft)
        let bottomRight = corners.contains(.bottomRight)
        
        let radius = min(self.radius, min(rect.width, rect.height) / 2)
        
        path.move(to: CGPoint(x: rect.minX + (topLeft ? radius : 0), y: rect.minY))
        
        //Top
        path.addLine(to: CGPoint(x: rect.maxX - (topRight ? radius : 0), y: rect.minY))
        if topRight {
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: Angle(degrees: -90),
                       endAngle: Angle(degrees: 0),
                       clockwise: false)
        }
        //Right
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - (bottomRight ? radius : 0)))
        if bottomRight {
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                       radius: radius,
                       startAngle: Angle(degrees: 0),
                       endAngle: Angle(degrees: 90),
                       clockwise: false)
        }
        //Bottom
        path.addLine(to: CGPoint(x: rect.minX + (bottomLeft ? radius : 0), y: rect.maxY))
        if bottomLeft {
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                       radius: radius,
                       startAngle: Angle(degrees: 90),
                       endAngle: Angle(degrees: 180),
                       clockwise: false)
        }
        //Left
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + (topLeft ? radius : 0)))
        if topLeft {
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: Angle(degrees: 180),
                       endAngle: Angle(degrees: 270),
                       clockwise: false)
        }
        path.closeSubpath()
        return path
        #endif
    }
}

extension View {
    #if canImport(UIKit)
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner, borderColor: Color? = nil, borderWidth: CGFloat? = nil) -> some View {
        overlay(
            RoundedCorner(radius: radius, corners: corners)
                .stroke(borderColor ?? Color.clear, lineWidth: borderWidth ?? 1)
        )
        .clipShape(
            RoundedCorner(radius: radius, corners: corners)
        )
    }
    #elseif canImport(AppKit)
    func cornerRadius(_ radius: CGFloat, corners: PlatformRectCorner, borderColor: Color? = nil, borderWidth: CGFloat? = nil) -> some View {
        overlay(
            RoundedCorner(radius: radius, corners: corners)
                .stroke(borderColor ?? Color.clear, lineWidth: borderWidth ?? 1)
        )
        .clipShape(
            RoundedCorner(radius: radius, corners: corners)
        )
    }
    #endif
}
