//
//  PhotoSelector.swift
//
//
//  Created by Szymon Wnuk on 08/10/2024.
//

import PhotosUI
import SwiftUI


struct PhotoSelector: View {
    @State var selectedItems: [PhotosPickerItem] = []
    @State private var maxSelectionCount: Int = 3
    @State private var selectedImages: [Image] = []

    var body: some View {
        HStack {
            ForEach(0..<selectedImages.count, id: \.self) { index in
                selectedImages[index]
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            if selectedImages.count < maxSelectionCount {
                PhotosPicker(selection: $selectedItems, maxSelectionCount: maxSelectionCount - selectedImages.count, matching: .images) {
                    ImagePickerLabel()
                }
            }
            Spacer()
        }
        .buttonStyle(.plain)
        .applyHoverEffectDisabledIfAvailable()
        .onChange(of: selectedItems) { items in
            Task {
                selectedImages.removeAll()
                for item in items {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImages.append(Image(uiImage: uiImage))
                    }
                }
            }
        }
    }
}

extension View {
    func applyHoverEffectDisabledIfAvailable() -> some View {
        if #available(iOS 17.0, *) {
            return AnyView(self.hoverEffectDisabled())
        } else {
            return AnyView(self)
        }
    }
}
