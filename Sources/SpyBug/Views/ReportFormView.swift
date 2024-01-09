//
//  RequestView.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI

@available(iOS 15.0, *)
struct RequestView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var bugUIImages = [UIImage]()
    @State private var text = ""
    @State private var buttonPressed: Bool = false
    @State private var showTextError: Bool = false
    
    var apiKey: String
    var authorId: String?
    var type: ReportType
    
    private var isBugReport: Bool {
        type == ReportType.bug
    }
    
    var body: some View {
        VStack {
            TitleAndBackButton()
            
            ImagePicker()
            
            Text(isBugReport ? "Add comment" : "Add description")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.black.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            AddDescription()
            
            Spacer()
            
            Button {
                if !isBugReport {
                    buttonPressed.toggle()
                }
                Task {
                    do {
                        let result = try await SpyBugService().createBugReport(apiKey: apiKey, reportIn: ReportCreate(description: text, type: type, authorEmail: authorId))
                        
                        if isBugReport {
                            let imageDataArray = bugUIImages.map { image in
                                guard let imageData = image.jpegData(compressionQuality: 0.8) else { fatalError("Image data compression failed") }
                                return imageData
                            }
                            
                            _ = try await SpyBugService().addPicturesToCreateBugReport(apiKey: apiKey, reportId: result.id, pictures: imageDataArray)
                        }
                        
                        dismiss()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                HStack {
                    Text("Send request")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.black.opacity(0.8))
                    
                    Spacer()
                    
                    Image(systemName: "paperplane")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.black.opacity(0.8))
                        .padding(.trailing)
                }
                .padding(.horizontal)
                .frame(height: 69)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .gray.opacity(0.25), radius: 4)
                )
            }
        }
        .frame(height: 450)
        .navigationBarHidden(true)
        .padding()
        .background(Color.white.opacity(0.1))
        .onChange(of: buttonPressed) { newValue in
            showTextError = true
        }
    }
    
    @ViewBuilder
    private func ImagePicker() -> some View {
        if isBugReport {
            VStack {
                Text("Add screenshots")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                ReportProblemImagePicker(problemUIImages: $bugUIImages)
            }
        }
    }
    
    @ViewBuilder
    private func TitleAndBackButton() -> some View {
        HStack(alignment: .center) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundStyle(.black.opacity(0.6))
                    .padding(.leading)
            }
            Spacer()
            Text(type.title)
                .font(.system(size: 24, weight: .bold))
            
            Spacer()
            //Cheap way to center the title
            Image(systemName: "chevron.left")
                .font(.system(size: 28, weight: .regular))
                .padding(.leading)
                .hidden()
        }
        .frame(height: 36)
        .padding(.bottom)
        .buttonStyle(.plain)
    }
    
    @available(iOS 15.0, *)
    @ViewBuilder
    private func AddDescription() -> some View {
        ZStack {
            if text.isEmpty {
                VStack {
                    HStack {
                        Text(showTextError ? "This field should not be empty" : "Type here...")
                            .foregroundStyle(showTextError ? .red : .black.opacity(0.7))
                            .font(.system(size: 16, weight: .regular))
                            .padding(.top, 2)
                        Spacer()
                    }
                    Spacer()
                }
                .padding([.top, .leading], 4)
            }
            HStack {
                if #available(iOS 16.0, *) {
                    TextEditor(text: $text)
                        .scrollContentBackground(.hidden)
                    Spacer()
                } else {
                    TextEditor(text: $text)
                    Spacer()
                }
            }
        }
        .frame(height: isBugReport ? 50 : 200)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .cornerRadius(25, corners: .allCorners)
                .shadow(color: .black.opacity(0.15), radius: 5)
        )
    }
}

@available(iOS 15.0, *)
#Preview {
    NavigationView {
        RequestView(apiKey: "", type: .bug)
    }
}
