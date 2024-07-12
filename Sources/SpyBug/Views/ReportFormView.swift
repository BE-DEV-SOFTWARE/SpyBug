//
//  ReportFormView.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI


struct ReportFormView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var bugUIImages = [UIImage]()
    @State private var text = ""
    @State private var buttonPressed: Bool = false
    @State private var showTextError: Bool = false
    @State private var isLoading = false
    @State private var showSuccessErrorView: ViewState?
    @State private var timer: Timer?
    @Binding var showReportForm: Bool
    var apiKey: String
    var author: String?
    var type: ReportType
    
    private var isBugReport: Bool {
        type == ReportType.bug
    }
    
    var body: some View {
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
                    .onAppear {
                        startTimer()
                        Task {
                            await sendRequest()
                        }
                    }
                    .background(Color(.background))
            } else {
                TitleAndBackButton(showReportForm: $showReportForm, type: type)
                ImagePicker()
                
                Text(isBugReport ? "Add comment" : "Add description")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color(.secondary))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                AddDescription()
                
                Spacer()
                
                Button {
                    if text.isEmpty {
                        showTextError = true
                    } else {
                        isLoading = true
                        buttonPressed.toggle()
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
                            .fill(spyBugGradient)
                            .shadow(color: Color(.shadow), radius: 4)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
        .background(Color(.background))
        .onChange(of: buttonPressed) { newValue in
            if newValue && !text.isEmpty {
                Task {
                    await sendRequest()
                }
            }
        }
    }
    
    private func sendRequest() async {
        do {
            let result = try await SpyBugService().createBugReport(apiKey: apiKey, reportIn: ReportCreate(description: text, type: type, authorEmail: author))
            
            if isBugReport {
                let imageDataArray = bugUIImages.map { image in
                    guard let imageData = image.jpegData(compressionQuality: 0.8) else { fatalError("Image data compression failed") }
                    return imageData
                }
                
                _ = try await SpyBugService().addPicturesToCreateBugReport(apiKey: apiKey, reportId: result.id, pictures: imageDataArray)
            }
            
            timer?.invalidate()
            withAnimation {
                showSuccessErrorView = .success
                isLoading = false
            }
        } catch {
            timer?.invalidate()
            withAnimation {
                showSuccessErrorView = .error
                isLoading = false
            }
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { _ in
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
                Text("Add screenshots")
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
            Text(type.title)
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
    
    @ViewBuilder
    private func AddDescription() -> some View {
        ZStack {
            if text.isEmpty {
                VStack {
                    HStack {
                        Text(showTextError ? "This field should not be empty" : "Type here...")
                            .foregroundStyle(showTextError ? .red : Color(.secondary))
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
                .fill(Color(.button))
                .cornerRadius(25, corners: .allCorners)
                .shadow(color: Color(.shadow), radius: 5)
        )
    }
}


#Preview {
    ReportFormView(showReportForm: .constant(false), apiKey: "", type: .bug)
}
