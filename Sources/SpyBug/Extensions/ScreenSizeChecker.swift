//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 18/07/2024.
//

import SwiftUI

struct ScreenSizeChecker {
    static var isScreenHeightLessThan670: Bool {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight < 670
    }
}
