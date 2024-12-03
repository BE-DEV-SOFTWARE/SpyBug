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

    var body: some View {
        HStack {
            PhotosPicker(selection: $selectedItems, maxSelectionCount: 3, matching: .images) {
                ImagePickerLabel()
            }
            Spacer()
        }
        .buttonStyle(.plain)
        .applyHoverEffectDisabledIfAvailable()
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
