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
        SnapPix(uiImages: $problemUIImages, maxImageCount: 3, allowDeletion: true, addImageLabel: {
                RoundedRectangle(cornerRadius: 20)
                .fill(Color(.button))
                    .frame(width: 100, height: 100)
                    .shadow(color: Color(.shadow), radius: 8, x: 4, y: 4)
                    .overlay(
                        Image(systemName: "camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(spyBugGradient)
                    )
        })
            .padding(.bottom, 12)
            .padding(.top, 6)        
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

