//
//  ReportFormView.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI
import PhotosUI

struct ReportFormView: View {
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
                SuccessErrorView(state: showSuccessErrorView)
                    .onTapGesture {
                        withAnimation {
                            self.showSuccessErrorView = nil
                            self.showReportForm = false
                        }
                    }
            } else if isLoading {
                SendingView()
                    .background(Color(.background))
            } else {
                TitleAndBackButton(showReportForm: $showReportForm, type: type)
                
                ImagePicker()
                
                AddDescription()
                
                Spacer()
            }
        }
        .padding(.horizontal)
#if iOS
        .padding(.top, isTextEditorFocused && ScreenSizeChecker.isScreenHeightLessThan670 ? 16 : 0)
        .background(Color(.background))
#endif
        
        
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
    private func ImagePicker() -> some View {
        if isBugReport {
            VStack {
                Text("Add screenshots", bundle: .module)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(.secondary))
                    .frame(maxWidth: .infinity, alignment: .leading)
                ReportProblemImagePicker(problemUIImages: $bugUIImages)
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
                .foregroundStyle(Color(.darkBrown))
                .padding(.vertical, 8)
                .padding(.horizontal, 18)
        }
        .background {
            Capsule().fill(Color(.yellowOrange))
        }
        .disabled(isCharacterLimitReached)
    }
    
    @ViewBuilder
    private func TitleAndBackButton(showReportForm: Binding<Bool>, type: ReportType) -> some View {
        ZStack {
            HStack(alignment: .center) {
                Button {
                    KeyboardUtils.hideKeyboard()
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showReportForm.wrappedValue = false
                    }
                    
                    //SW: No back button?
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 28, weight: .regular))
                        .foregroundStyle(Color(.secondary))
                        .padding(.leading)
                }
                Spacer()
            }
            Text(type.shortTitle, bundle: .module)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(.title))
            HStack(alignment: .center) {
                Spacer()
                SendRequestNavigationButton()
            }
        }
        .padding(.bottom)
        .buttonStyle(.plain)
        
    }
    
    
    
    @ViewBuilder
    private func AddDescription() -> some View {
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
        .frame(height: isBugReport ? 60 : 200)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.button))
                .cornerRadius(25, corners: .allCorners)
                .shadow(color: Color(.shadow), radius: 5)
        )
    }
}


#Preview {
    TabView {
        ReportFormView(
            showReportForm: .constant(false),
            type: .bug
        )
        .tabItem {
            Image(.bug)
        }
        ReportFormView(
            showReportForm: .constant(false),
            type: .question
        )
        .tabItem {
            Image(.circleQuestion)
        }
        ReportFormView(
            showReportForm: .constant(false),
            type: .feature
        )
        .tabItem {
            Image(.rocket)
        }
        ReportFormView(
            showReportForm: .constant(false),
            type: .improvement
        )
        .tabItem {
            Image(.wand)
        }
    }
}
