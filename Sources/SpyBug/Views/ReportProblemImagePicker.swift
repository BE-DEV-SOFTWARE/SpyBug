//
//  ReportProblemImagePicker.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.


import SwiftUI
#if os(iOS) || os(visionOS)
import UIKit
import PhotosUI
#elseif os(macOS)
import AppKit
#endif
import UniformTypeIdentifiers

#if os(macOS)
typealias PlatformImage = NSImage
#else
typealias PlatformImage = UIImage
#endif

struct ReportProblemImagePicker: View {
    @Binding var problemUIImages: [PlatformImage]
#if os(iOS)
    @State private var selectedCameraImage: UIImage?
    @State private var isShowingCameraPicker = false
#endif

    @Binding var files: [URL]
    @State private var isShowingFileImporter = false
    @State private var isShowingActionSheet = false
    @State private var isShowingPhotosPicker = false
#if os(macOS)
    @State private var isPickingImagesOnMac = false
#endif
    
    private let maxAttachmentCount = 3
    private let maxFileSizeB = 2000 * 1024
    private let gridMin: CGFloat = 100
    private let spacing: CGFloat = 10
    
    private var canAddMoreAttachments: Bool {
        (problemUIImages.count + files.count) < maxAttachmentCount
    }
    
    private var remainingAttachmentSlots: Int {
        max(0, maxAttachmentCount - (problemUIImages.count + files.count))
    }
    
    var body: some View {
        VStack {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: gridMin))],
                spacing: spacing
            ) {
                ForEach(problemUIImages.indices, id: \.self) { index in
                    attachmentImageView(problemUIImages[index], index: index)
                }
                
                ForEach(Array(files.enumerated()), id: \.offset) { index, url in
                    FilePreviewView(url: url)
                        .overlay {
                            DeleteButton(index, isImage: false)
                        }
                        .id("file-\(index)-\(url.path)")
                }
                
                if canAddMoreAttachments {
                    Button {
                        isShowingActionSheet = true
                    } label: {
                        ImagePickerLabel()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .fileImporter(
            isPresented: $isShowingFileImporter,
            allowedContentTypes: fileImporterAllowedContentTypes,
            allowsMultipleSelection: true
        ) { result in
            DispatchQueue.main.async {
                handleFileImporterResult(result)
            }
        }
#if os(iOS)
        .sheet(isPresented: $isShowingCameraPicker) {
            CameraPicker(
                uiImage: $selectedCameraImage,
                isPresented: $isShowingCameraPicker
            )
        }
#endif
#if os(iOS) || os(visionOS)
        .sheet(isPresented: $isShowingPhotosPicker) {
            PHPickerView(
                selectedImages: $problemUIImages,
                isPresented: $isShowingPhotosPicker,
                maxSelectionCount: remainingAttachmentSlots
            )
        }
#endif
        .confirmationDialog(
            Text("Add attachment", bundle: .module),
            isPresented: $isShowingActionSheet,
            titleVisibility: .visible
        ) {
#if os(iOS)
            Button {
                isShowingCameraPicker = true
            } label: {
                Text("Camera", bundle: .module)
            }
#endif
            Button {
#if os(macOS)
                presentMacImporter(isPickingImages: true)
#else
                isShowingPhotosPicker = true
#endif
            } label: {
                Text("Photo library", bundle: .module)
            }
            Button {
#if os(macOS)
                presentMacImporter(isPickingImages: false)
#else
                isShowingFileImporter = true
#endif
            } label: {
                Text("Files", bundle: .module)
            }
            Button("Cancel", role: .cancel) {}
        }
#if os(iOS)
        .onChange(of: selectedCameraImage) { image in
            if let image = image {
                problemUIImages.append(image)
                selectedCameraImage = nil
            }
        }
#endif
        .padding(.bottom, 12)
        .padding(.top, 6)
    }
    
    private var allowedFileTypes: [UTType] {
        [
            .jpeg,
            .png,
            .pdf,
            UTType(filenameExtension: "xls"),
            UTType(filenameExtension: "xlsx"),
            UTType(filenameExtension: "gdoc"),
            UTType(filenameExtension: "gsheet"),
            UTType(filenameExtension: "doc"),
            UTType(filenameExtension: "docx"),
            UTType(filenameExtension: "ppt"),
            UTType(filenameExtension: "pptx"),
            .plainText
        ].compactMap { $0 }
    }

    private var fileImporterAllowedContentTypes: [UTType] {
#if os(macOS)
        return isPickingImagesOnMac ? imageTypes : allowedFileTypes
#else
        return allowedFileTypes
#endif
    }

    private func handleFileImporterResult(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
#if os(macOS)
            if isPickingImagesOnMac {
                addPickedImages(urls)
            } else {
                addPickedFiles(urls)
            }
#else
            addPickedFiles(urls)
#endif
        case .failure:
            break
        }
    }

#if os(macOS)
    private var imageTypes: [UTType] {
        [.image]
    }

    private func presentMacImporter(isPickingImages: Bool) {
        isShowingActionSheet = false
        DispatchQueue.main.async {
            self.isPickingImagesOnMac = isPickingImages
            self.isShowingFileImporter = true
        }
    }
#endif
    
    private func platformImage(_ image: PlatformImage) -> Image {
    #if os(macOS)
        Image(nsImage: image)
    #else
        Image(uiImage: image)
    #endif
    }
    
    @ViewBuilder
    private func attachmentImageView(_ image: PlatformImage, index: Int) -> some View {
        platformImage(image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                DeleteButton(index, isImage: true)
            }
            .id("image-\(index)")
    }

    private func addPickedFiles(_ urls: [URL]) {
        for url in urls {
            guard canAddMoreAttachments else { break }
            
            let urlPath = url.path
            guard !files.contains(where: { $0.path == urlPath }) else { continue }
            
            let hasAccess = url.startAccessingSecurityScopedResource()
            
            var shouldAdd = true
            
            if hasAccess {
                defer {
                    url.stopAccessingSecurityScopedResource()
                }
                
                do {
                    let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
                    if let fileSize = attributes[.size] as? Int {
                        shouldAdd = fileSize <= maxFileSizeB
                    }
                } catch {
                    shouldAdd = true
                }
            }
            
            if shouldAdd {
                files.append(url)
            }
        }
    }

#if os(macOS)
    private func addPickedImages(_ urls: [URL]) {
        var newImages: [NSImage] = []

        for url in urls.prefix(remainingAttachmentSlots) {
            guard url.startAccessingSecurityScopedResource() else { continue }
            defer { url.stopAccessingSecurityScopedResource() }

            guard let type = try? url.resourceValues(forKeys: [.contentTypeKey]).contentType,
                  type.conforms(to: .image) else {
                continue
            }

            do {
                let data = try Data(contentsOf: url)
                if let image = NSImage(data: data) {
                    newImages.append(image)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        problemUIImages.append(contentsOf: newImages)
    }
#endif
    
    @ViewBuilder
    private func DeleteButton(_ index: Int, isImage: Bool) -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    if isImage {
                        problemUIImages.remove(at: index)
                    } else {
                        files.remove(at: index)
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(Color.black.opacity(0.3)))
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .offset(x: 3, y: -6)
    }
    
    @ViewBuilder
    private func FilePreviewView(url: URL) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white)
            .frame(width: 100, height: 100)
            .shadow(color: .gray.opacity(0.4), radius: 8, x: 4, y: 4)
            .overlay {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                    Text(url.lastPathComponent)
                        .lineLimit(1)
                        .font(.caption)
                        .padding(.horizontal, 8)
                }
                .foregroundColor(.gray)
            }
    }
}

#if os(iOS)
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var uiImage: UIImage?
    @Binding var isPresented: Bool

    func makeCoordinator() -> CameraPickerCoordinator {
        CameraPickerCoordinator(uiImage: $uiImage, isPresented: $isPresented)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

class CameraPickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var uiImage: UIImage?
    @Binding var isPresented: Bool
    
    init(uiImage: Binding<UIImage?>, isPresented: Binding<Bool>) {
        self._uiImage = uiImage
        self._isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.uiImage = pickedImage
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
}
#endif

#if os(iOS) || os(visionOS)
struct PHPickerView: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Binding var isPresented: Bool
    let maxSelectionCount: Int
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = maxSelectionCount
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PHPickerView
        
        init(_ parent: PHPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false
            
            guard !results.isEmpty else { return }
            
            for result in results {
                guard parent.selectedImages.count < parent.maxSelectionCount else { break }
                
                let itemProvider = result.itemProvider
                _ = itemProvider.loadTransferable(type: Data.self) { (loadResult: Result<Data, Error>) in
                    switch loadResult {
                    case .success(let data):
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(image)
                            }
                        }
                    case .failure:
                        break
                    }
                }
            }
        }
    }
}
#endif

