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
    @State private var buttonPressed = false
    @State private var showTextError = false
    @State private var isLoading = false
    @State private var showSuccessErrorView: ViewState?
    @Binding var showReportForm: Bool
    @FocusState private var isTextEditorFocused: Bool
    
    
    var author: String?
    var type: ReportType
    
    private var isBugReport: Bool {
        type == ReportType.bug
    }
    
    private var isCharacterLimitReached: Bool {
        text.count > 500
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            if let showSuccessErrorView = showSuccessErrorView {
                SuccessErrorViewVisionOS(state: showSuccessErrorView)
                    .onTapGesture {
                        withAnimation {
                            self.showSuccessErrorView = nil
                            self.showReportForm = false
                        }
                    }
            } else if isLoading {
                SendingView()
            }else {
                TitleAndBackButtonVisionOS(showReportForm: $showReportForm, type: type)
                
                ImagePicker()
                
                AddDescription()
                
                Spacer()
                
                SendRequestNavigationButton()
                
            }}
        .padding(.horizontal)
        
        .onChange(of: buttonPressed) { newValue in
            if newValue && !text.isEmpty {
                Task {
                    await sendRequest()
                }
            }
        }
        .onTapGesture {
            KeyboardUtils.hideKeyboard()
        }
    }
    
    
    private func sendRequestValidation() {
        if text.isEmpty {
            showTextError = true
        } else {
            isLoading = true
            buttonPressed.toggle()
        }
    }
    
    private func sendRequest() async {
        do {
            let result = try await SpyBugService().createBugReport(reportIn: ReportCreate(description: text, type: type, authorEmail: author))
            
            if isBugReport && !bugUIImages.isEmpty {
                let imageDataArray = bugUIImages.map { image in
                    guard let imageData = image.jpegData(compressionQuality: 0.8) else { fatalError("Image data compression failed") }
                    return imageData
                }
                
                _ = try await SpyBugService().addPicturesToCreateBugReport(reportId: result.id, pictures: imageDataArray)
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
        Button {
            sendRequestValidation()
        } label: {
            Text("Send")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color(.black))
                .padding(.vertical, 8)
                .padding(.horizontal, 18)
                .frame(maxWidth: .infinity, maxHeight: 55)
            
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.white)
                    
                }
                .disabled(isCharacterLimitReached)
        }
        .buttonStyle(.plain)
        .padding(.bottom)
    }
    
    @ViewBuilder
    private func ImagePicker() -> some View {
        if isBugReport {
            VStack {
                Text("Add screenshots", bundle: .module)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(.secondary))
                    .frame(maxWidth: .infinity, alignment: .leading)
#if os(visionOS)
                PhotoSelector()
#endif
      
                
            }
        }
    }
    
    @ViewBuilder
    private func TitleAndBackButtonVisionOS(showReportForm: Binding<Bool>, type: ReportType) -> some View {
        HStack(alignment: .center) {
            Button {
                KeyboardUtils.hideKeyboard()
                withAnimation(.easeInOut(duration: 0.3)) {
                    showReportForm.wrappedValue = false
                }
            } label: {
                RoundedLabel(reportType: type)
            }
            Text(type.shortTitle, bundle: .module)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(.title))
            Spacer()
        }
        
        .padding(.top, 15)
        .padding(.horizontal, 10)
        .hoverEffect()
        .buttonStyle(.plain)
        
    }
    
    @ViewBuilder
    private func RoundedLabel(reportType: ReportType) -> some View {
        
        
        reportType.iconVisionOS
            .resizable()
            .frame(width: 25, height: 25)
            .padding(5)
            .background(Circle()
                .foregroundStyle(.black.opacity(0.2))
            )
    }
    
    @ViewBuilder
    private func AddDescription() -> some View {
        if #available(iOS 17.0, *) {
            ZStack {
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
                        } else {
                            TextEditor(text: $text)
                                .focused($isTextEditorFocused)
                            Spacer()
                        }
                    }
                    HStack {
                        Spacer()
                        DescriptionValidation(text: text)
                    }
                    .offset(x: 4, y: 8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.top)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.black.opacity(0.2)))
                    .cornerRadius(25, corners: .allCorners)
                    .shadow(color: Color(.shadow), radius: 5)
            )
            .hoverEffect()
            .buttonStyle(.plain)
        } 
    }
}


