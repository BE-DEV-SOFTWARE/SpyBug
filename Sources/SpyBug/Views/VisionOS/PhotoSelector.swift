//
//  PhotoSelector.swift
//
//
//  Created by Szymon Wnuk on 08/10/2024.
//

import PhotosUI
import SwiftUI

#if os(visionOS)
struct PhotoSelector: View {
    @State var selectedItems: [PhotosPickerItem] = []
    @State private var maxSelectionCount: Int = 3
    
    var body: some View {
        HStack{
            PhotosPicker(selection: $selectedItems, maxSelectionCount: 3, matching: .images, label: {
                ImagePickerLabel()
            }
            )
            Spacer()
        }
        .hoverEffect()
        .buttonStyle(.plain)
    }
}
#endif

