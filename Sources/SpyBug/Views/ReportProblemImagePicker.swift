//
//  ReportProblemImagePicker.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.


import SwiftUI
import SnapPix

struct ReportProblemImagePicker: View {
    @Binding var problemUIImages: [UIImage]
    @Binding var files: [URL]
    
    var body: some View {
        SnapPix(
            uiImages: $problemUIImages,
            files: $files,
            uploadMode: .both,
            maxImageCount: 3,
            maxFileSizeB: 2000 * 1024,
            allowDeletion: true,
            addItemLabel: { (_: UploadMode) in
                ImagePickerLabel()
            }
        )
        .buttonStyle(.plain)
        .padding(.bottom, 12)
        .padding(.top, 6)
    }
}


