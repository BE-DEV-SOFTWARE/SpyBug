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
    @State private var problemsUIImages = [UIImage]()
    @State var isShowingXmark = false
    @State private var text = ""
    @State private var buttonPressed: Bool = false
    @State private var showTextError: Bool = false
    var title: LocalizedStringKey = ""
    var buttonText: LocalizedStringKey = ""
    var isOpenForReportAProblem = false
    var apiKey: String
    var authorId: String?
    var reportType: ReportType?
    
    var body: some View {
        VStack {
            TitleAndBackButton()
            
            ImagePicker()
            
            Text(isOpenForReportAProblem ? "Add comment" : "Add description")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.black.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            AddDescription()
            
            Spacer()
            
            Button {
                if !isOpenForReportAProblem {
                    buttonPressed.toggle()
                }
                Task {
                    do {
                        let result = try await SpyBugService().createBugReport(apiKey: apiKey, reportIn: ReportCreate(description: text, type: reportType!, authorEmail: authorId))
                        
                        if reportType == .bug {
                            let imageDataArray = problemsUIImages.map { image in
                                guard let imageData = image.jpegData(compressionQuality: 0.8) else { fatalError("Image data compression failed") }
                                return imageData
                            }
                            
                            try await SpyBugService().addPicturesToCreateBugReport(apiKey: apiKey, reportId: result.id, pictures: imageDataArray)
                        }
                        
                        dismiss()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                HStack {
                    Text(buttonText)
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
        .onTapGesture {
            isShowingXmark.toggle()
        }
        .onChange(of: buttonPressed) { newValue in
            showTextError = true
        }
    }
    
    @ViewBuilder
    private func ImagePicker() -> some View {
        if isOpenForReportAProblem {
            VStack {
                Text("Add screenshots")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                ReportProblemImagePicker(problemUIImages: $problemsUIImages, isShowingXmark: $isShowingXmark)
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
            Text(title)
                .font(.system(size: 24, weight: .bold))
            
            Spacer()
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
        .frame(height: isOpenForReportAProblem ? 50 : 200)
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
struct RequestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RequestView(isOpenForReportAProblem: true, apiKey: "")
        }
    }
}
