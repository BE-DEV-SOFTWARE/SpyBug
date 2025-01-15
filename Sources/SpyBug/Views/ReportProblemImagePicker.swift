//
//  ReportProblemImagePicker.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.


import SwiftUI
import SnapPix

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


