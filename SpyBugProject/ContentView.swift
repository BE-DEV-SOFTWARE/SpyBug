//
//  ContentView.swift
//  SpyBugProject
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI
import SpyBug

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            SpyBug()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
