//
//  ReportProblemImagePicker.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.


import SwiftUI
import SnapPix

import SwiftUI

struct ReportProblemImagePicker: View {
    @Binding var problemUIImages: [UIImage]
    
    var body: some View {
        SnapPix(uiImages: $problemUIImages, maxImageCount: 3, allowDeletion: true, addImageLabel: {
            ImagePickerLabel()
        })
        .buttonStyle(.plain)
        .padding(.bottom, 12)
        .padding(.top, 6)
    }
    
    
}

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
