//
//  ReportProblemImagePicker.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.


import SwiftUI
import SnapPix

struct ReportProblemImagePicker: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var problemUIImages: [UIImage]
    
    // TODO: Make it work even if the images are not all sent
    
    var body: some View {
        //TODO: update SnapPix to have a "allowDeletion" option that should not be a binding instead of isShowingXmark
        SnapPix(uiImages: $problemUIImages, maxImageCount: 3, allowDeletion: true, addImageLabel: {
            
                RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .light ? .white : .black.opacity(0.8))
                    .frame(width: 100, height: 100)
                    .shadow(color: .gray.opacity(0.4), radius: 8, x: 4, y: 4)
                    .overlay(
                        Image(systemName: "camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(colorScheme == .light ?
                                             Color.black.opacity(0.6) : .white.opacity(0.45))
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

