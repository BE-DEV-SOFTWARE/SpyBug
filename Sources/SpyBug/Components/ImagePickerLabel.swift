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
            .fill(Color(.button))
            .cornerRadius(25, corners: .allCorners)
            .frame(width: 100, height: 100)
            .shadow(color: Color(.shadow), radius: 5)
            .overlay(
                Image(systemName: "camera")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            )          
    }
}

#Preview {
    ImagePickerLabel()
}
