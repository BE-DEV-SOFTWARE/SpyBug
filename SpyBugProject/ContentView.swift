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
            SpyBugButton(apiKey: "", author: "") { }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}


