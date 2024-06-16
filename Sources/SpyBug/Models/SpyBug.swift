//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 16/06/2024.
//

import SwiftUI

public class SpyBug: ObservableObject {
    @Published public var isPresented = false
    
    public static let shared = SpyBug()
}
