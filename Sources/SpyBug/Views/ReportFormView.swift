//
//  ReportFormView.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI


struct ReportFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var bugUIImages = [UIImage]()
    @State private var text = ""
    @State private var buttonPressed: Bool = false
    @State private var showTextError: Bool = false
    @State private var isLoading = false
    @State private var showSuccessErrorView: ViewState?
    @Binding var showReportForm: Bool
    @FocusState private var isTextEditorFocused: Bool
    
    var author: String?
    var type: ReportType
    
    private var isBugReport: Bool {
        type == ReportType.bug
    }
    
    var body: some View {
        NavigationView {
            VStack {
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
                    
                    Text("Add description", bundle: .module)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color(.secondary))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    AddDescription()
                    
                    if !isTextEditorFocused {
                        Spacer()
                        
                        SendRequestButton()
                    }
                }
            }
            .padding(.top, isTextEditorFocused && ScreenSizeChecker.isScreenHeightLessThan670 ? 16 : 0)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal)
            .background(Color(.background))
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
    }
    
    private func sendRequest() async {
        do {
            let result = try await SpyBugService().createBugReport(reportIn: ReportCreate(description: text, type: type, authorEmail: author))
            
            if isBugReport {
                let imageDataArray = bugUIImages.map { image in
                    guard let imageData = image.jpegData(compressionQuality: 0.8) else { fatalError("Image data compression failed") }
                    return imageData
                }
                _ = try await SpyBugService().addPicturesToCreateBugReport(reportId: result.id, pictures: imageDataArray)
            }
            withAnimation {
                showSuccessErrorView = .success
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
    private func SendRequestButton() -> some View {
        Button {
            sendRequestAction()
        } label: {
            HStack {
                Spacer()
                Text("Send request", bundle: .module)
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
                    .fill(spyBugGradient)
                    .shadow(color: Color(.shadow), radius: 4)
            )
        }
        .buttonStyle(.plain)
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
    private func TitleAndBackButton(showReportForm: Binding<Bool>, type: ReportType) -> some View {
        HStack(alignment: .center) {
            Button {
                KeyboardUtils.hideKeyboard()
                withAnimation {
                    showReportForm.wrappedValue = false
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundStyle(Color(.secondary))
                    .padding(.leading)
            }
            Spacer()
            Text(type.title, bundle: .module)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(.title))
            
            Spacer()
            // Cheap way to center the title
            Image(systemName: "chevron.left")
                .font(.system(size: 28, weight: .regular))
                .padding(.leading)
                .hidden()
        }
        .frame(height: 36)
        .padding(.bottom)
        .buttonStyle(.plain)
    }
    
    func sendRequestAction() {
        if text.isEmpty {
            showTextError = true
        } else {
            isLoading = true
            buttonPressed.toggle()
        }
        KeyboardUtils.hideKeyboard()
    }
    
    @ViewBuilder
    private func AddDescription() -> some View {
        HStack {
            TextEditor(text: $text)
                .disableAutocorrection(true)
                .keyboardType(.alphabet)
                .focused($isTextEditorFocused)
                .modifier(KeyboardSendRequestButton(action: {
                    sendRequestAction()
                }))
            Spacer()
        }
        .overlay {
            if text.isEmpty {
                VStack {
                    HStack {
                        Text(showTextError ? "This field should not be empty" : "Type here...", bundle: .module)
                            .foregroundStyle(showTextError ? .red : Color(.secondary))
                            .font(.system(size: 16, weight: .regular))
                            .padding(.top, 2)
                        Spacer()
                    }
                    Spacer()
                }
                .padding([.top, .leading], 6)
                .onTapGesture {
                    isTextEditorFocused = true
                }
            }
        }
        .frame(height: isBugReport ? 50 : 200)
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
