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
            
            SpyBug(apiKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyN2E0ZTg2MS0zZDc5LTRmMmItYmExZS0xYTZlYzlhYzYxYTAifQ.JI8TA_5kD2CuAZD2fUCnXJ89JICWgIKY5i9wsLmbkGg")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
