//
//  ReportProblemImagePicker.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.


import SwiftUI
import SnapPix

struct ReportProblemImagePicker: View {
    @Binding var problemUIImages: [UIImage]
    @Binding var isShowingXmark: Bool
    
    // TODO: Make it work even if the images are not all sent
    
    var body: some View {
        SnapPix(
            uIImages: $problemUIImages,
            imageCount: 3,
            cameraImage: Image(packageResource: "cameraImage", ofType: "png"),
            imageCornerRadius: 25,
            frameHeight: 150,
            frameWidth: 116,
            imageHeight: 46,
            gridMinumum: 100,
            spacing: 16,
            isShowingXMark: $isShowingXmark,
            xMarkColor: .white,
            xMarkOffset: CGSize(width: 50, height: -70),
            xMarkFrame: CGSize(width: 30, height: 30),
            shadowColor: .black.opacity(0.1),
            shadowRadius: 4,
            shadowPosition: CGPoint(x: 0, y: 0)
        )
    }
}

#if DEBUG
struct ReportProblemImagePicker_Previews: PreviewProvider {
    @State static var selectedImages: [UIImage] = [UIImage(imageLiteralResourceName: "AppIcon"), UIImage(imageLiteralResourceName: "AppIcon"), UIImage(imageLiteralResourceName: "AppIcon")]
    static var previews: some View {
        ReportProblemImagePicker(problemUIImages: $selectedImages, isShowingXmark: .constant(false))
    }
}
#endif

