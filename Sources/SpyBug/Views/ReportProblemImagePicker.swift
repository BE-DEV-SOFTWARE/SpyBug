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
    // TODO: Make it work even if the images are not all sent
    
    var body: some View {
        SnapPix(uiImages: $problemUIImages, files: $files, maxImageCount: 3, maxFileSizeB: 2000 * 1024, allowDeletion: true, addItemLabel: {_ in
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.mischkaGray))
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color(.graySuccess))
                )
        })
        .padding(.top, 6)
    }
}

