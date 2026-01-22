//
//  ReportFormViewVisionOS.swift
//  SpyBug
//
//  Created by Szymon Wnuk on 25/11/2024.
//

import SwiftUI

import PhotosUI

struct ReportFormViewVisionOS: View {
    @State private var bugUIImages = [UIImage]()
    @State private var text = ""
    @State private var showTextError = false
    @State private var isLoading = false
    @State private var showSuccessErrorView: ViewState?
    @Binding var showReportForm: Bool
    @FocusState private var isTextEditorFocused: Bool
    
    var author: String?
    var type: ReportType
    var onDismissWindow: (() -> Void)?
    
    private var isBugReport: Bool {
        type == ReportType.bug
    }
    
    private var isCharacterLimitReached: Bool {
        text.count > 500
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if let showSuccessErrorView = showSuccessErrorView {
                SuccessErrorViewVisionOS(state: showSuccessErrorView, onDismiss: {
                    onDismissWindow?()
                })
            } else if isLoading {
                SendingView()
            } else {
                TitleAndBackButtonVisionOS(showReportForm: $showReportForm, type: type)
                
                ImagePicker()
                
                AddDescription()
                
                Spacer()
                
                SendRequestNavigationButton()
            }
        }
        .padding(24)
    }
    
    private func submit() {
        if text.isEmpty {
            showTextError = true
        } else {
            isLoading = true
            Task {
                await sendRequest()
            }
        }
    }
    
    private func sendRequest() async {
        do {
            let result = try await SpyBugService().createBugReport(reportIn: ReportCreate(description: text, type: type, authorId: author))
            
            if isBugReport && !bugUIImages.isEmpty {
                let imageDataArray = bugUIImages.map { image in
                    guard let imageData = image.jpegData(compressionQuality: 0.8) else { fatalError("Image data compression failed") }
                    return imageData
                }
                
                _ = try await SpyBugService().addPicturesToCreateBugReport(reportId: result.id, files: imageDataArray)
            }
            
            withAnimation {
                showSuccessErrorView = .success(reportType: type)
                isLoading = false
            }
        } catch {
            withAnimation {
                showSuccessErrorView = .error
                isLoading = false
            }
        }
    }
    
    @ViewBuilder
    private func SendRequestNavigationButton() -> some View {
        Button(action: submit) {
            HStack{
                Spacer()
                Text("Send", bundle: .module)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(Color.primary)
                Spacer()
            }
            .padding()
            .frame(height: 55)
        }
    }
    
    @ViewBuilder
    private func ImagePicker() -> some View {
        if isBugReport {
            VStack {
                Text("Add screenshots", bundle: .module)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(.secondary))
                    .frame(maxWidth: .infinity, alignment: .leading)
                PhotoSelector(selectedUIImages: $bugUIImages)
            }
        }
    }
    
    @ViewBuilder
    private func TitleAndBackButtonVisionOS(showReportForm: Binding<Bool>, type: ReportType) -> some View {
        HStack(alignment: .center) {
            Button("Back", systemImage: "chevron.left") {
                KeyboardUtils.hideKeyboard()
                withAnimation(.easeInOut(duration: 0.3)) {
                    showReportForm.wrappedValue = false
                }
            }
            .buttonStyle(.bordered)
            .labelStyle(.iconOnly)
            
            Spacer()
            
            RoundedLabel(reportType: type)
            Text(type.shortTitle, bundle: .module)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(.title))
            
            Spacer()
            
            Spacer()
                .frame(width: 44)
        }
    }
    
    @ViewBuilder
    private func RoundedLabel(reportType: ReportType) -> some View {
        reportType.icon
            .resizable()
            .frame(width: 25, height: 25)
            .padding(5)
    }
    
    @ViewBuilder
    private func AddDescription() -> some View {
        ZStack{
            if text.isEmpty {
                VStack {
                    HStack {
                        Text(showTextError ? "This field should not be empty" : "Add a description here...", bundle: .module)
                            .foregroundStyle(showTextError ? .red : Color(.secondary))
                            .font(.system(size: 16, weight: .regular))
                            .padding(.top, 2)
                        Spacer()
                    }
                    Spacer()
                }
                .padding([.top, .leading], 4)
            }
            VStack {
                HStack {
                    if #available(iOS 16.0, *) {
                        TextEditor(text: $text)
                            .scrollContentBackground(.hidden)
                            .focused($isTextEditorFocused)
                        Spacer()
                    }
                    else {
                        TextEditor(text: $text)
                            .focused($isTextEditorFocused)
                        Spacer()
                    }
                }
                HStack {
                    Spacer()
                    DescriptionValidation(text: text)
                }
                .offset(x: 4, y: 15)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.top)
        .padding(0)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.black.opacity(0.2))
                .cornerRadius(25, corners: .allCorners)
                .shadow(color: Color(.shadow), radius: 5)
        )
        .buttonStyle(.plain)
    }
    
}
