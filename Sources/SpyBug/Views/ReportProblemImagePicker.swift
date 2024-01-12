//
//  ReportProblemImagePicker.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.


import SwiftUI
import SnapPix

struct ReportProblemImagePicker: View {
    @Binding var problemUIImages: [UIImage]
    
    // TODO: Make it work even if the images are not all sent
    
    var body: some View {
        //TODO: update SnapPix to have a "allowDeletion" option that should not be a binding instead of isShowingXmark
        SnapPix(
            uIImages: $problemUIImages,
            imageCount: 3,
            cameraImage: Image.camera,
            imageCornerRadius: 25,
            frameHeight: 150,
            frameWidth: 116,
            imageHeight: 46,
            gridMinumum: 100,
            spacing: 16,
            isShowingXMark: .constant(true),
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
//TODO: Fix this preview
//struct ReportProblemImagePicker_Previews: PreviewProvider {
//    @State static var selectedImages: [UIImage] = [UIImage(imageLiteralResourceName: "AppIcon"), UIImage(imageLiteralResourceName: "AppIcon"), UIImage(imageLiteralResourceName: "AppIcon")]
//    static var previews: some View {
//        ReportProblemImagePicker(problemUIImages: $selectedImages)
//    }
//}
#endif

