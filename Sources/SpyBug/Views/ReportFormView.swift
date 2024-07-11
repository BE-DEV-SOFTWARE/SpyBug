//
//  ReportFormView.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI

@available(iOS 15.0, *)
struct ReportFormView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var bugUIImages = [UIImage]()
    @State private var text = ""
    @State private var buttonPressed: Bool = false
    @State private var showTextError: Bool = false
    @State private var isLoading = false
    
    var apiKey: String
    var author: String?
    var type: ReportType
    
    private var isBugReport: Bool {
        type == ReportType.bug
    }
    
    var body: some View {
        VStack {
            
            if isLoading{
                SendingView()
                    .frame(height: 500)
                    .navigationBarHidden(true)
                    .padding()
                    .background(Color.backgroundColor)
                    
                    
            } else {
                TitleAndBackButton()
                
                ImagePicker()
                
                Text(isBugReport ? "Add comment" : "Add description")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                AddDescription()
                
                Spacer()
                
                Button {
                    if !isBugReport {
                        buttonPressed.toggle()
                    }
                    Task {
                        do {
                            isLoading = true
                            let result = try await SpyBugService().createBugReport(apiKey: apiKey, reportIn: ReportCreate(description: text, type: type, authorEmail: author))
                            
                            if isBugReport {
                                let imageDataArray = bugUIImages.map { image in
                                    guard let imageData = image.jpegData(compressionQuality: 0.8) else { fatalError("Image data compression failed") }
                                    return imageData
                                }
                                
                                _ = try await SpyBugService().addPicturesToCreateBugReport(apiKey: apiKey, reportId: result.id, pictures: imageDataArray)
                            }
                                                      try await Task.sleep(nanoseconds: 2_000_000_000) 
                                                      isLoading = false
                                                      dismiss()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Send request")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                        
                        Image(systemName: "paperplane")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                            .padding(.trailing)
                    }
                    .padding(.horizontal)
                    .frame(height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(.linearGradient(colors: [.linearOrange, .linearRed], startPoint: .leading, endPoint: .trailing))
                            .shadow(color: Color.shadowColor, radius: 4)
                    )
                }
            }}
                .frame(height: 500)
                .navigationBarHidden(true)
                .padding()
                .background(Color.backgroundColor)
                .onChange(of: buttonPressed) { newValue in
                    showTextError = true
                
        }}
    
    @ViewBuilder
    private func ImagePicker() -> some View {
        if isBugReport {
            VStack {
                Text("Add screenshots")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color.secondary)
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
                    .foregroundStyle(Color.secondary)
                    .padding(.leading)
            }
            Spacer()
            Text(type.title)
                .font(.system(size: 24, weight: .bold))     .foregroundStyle(Color.titleColor)
            
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
                            .foregroundStyle(showTextError ? .red :
                                    .secondary)
                        
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
                .fill(Color.buttonColor)
                .cornerRadius(25, corners: .allCorners)
                .shadow(color: .shadowColor, radius: 5)
        )
    }
}

@available(iOS 15.0, *)
#Preview {
    NavigationView {
        ReportFormView(apiKey: "", type: .bug)
    }
}
