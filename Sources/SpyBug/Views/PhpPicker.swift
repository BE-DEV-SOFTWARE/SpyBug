//
//  File.swift
//  
//
//  Created by Szymon Wnuk on 08/10/2024.
//

import PhotosUI
import SwiftUI

//var body: some View {
//      VStack {
//          PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
//
//          avatarImage?
//              .resizable()
//              .scaledToFit()
//              .frame(width: 300, height: 300)
//      }
//      .onChange(of: avatarItem) {
//          Task {
//              if let loaded = try? await avatarItem?.loadTransferable(type: Image.self) {
//                  avatarImage = loaded
//              } else {
//                  print("Failed")
//              }
//          }
//      }
//  }
//> than 1.0 visionOS try with windowgroupsd
//1 define window group
//2 id
//3 open window from environment, on click u open window with the id u created. 

struct PhpPicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 3
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhpPicker
        
        init(_ parent: PhpPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            for result in results {
                let provider = result.itemProvider
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, _ in
                        if let uiImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(uiImage)
                            }
                        }
                    }
                }
            }
        }
    }
}

