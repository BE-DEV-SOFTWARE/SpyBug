//
//  SwiftUIView.swift
//  SpyBug
//
//  Created by Szymon Wnuk on 25/11/2024.
//

import SwiftUI

struct ImagePickerLabel: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white.opacity(0.3))
            .frame(width: 100, height: 100)
            .shadow(color: Color(.shadow), radius: 8, x: 4, y: 4)
            .overlay(
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            )
    }
}
