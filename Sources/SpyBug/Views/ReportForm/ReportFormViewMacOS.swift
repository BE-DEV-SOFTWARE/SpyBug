//
//  ReportFormViewMacOS.swift
//
//
//  Created by Cursor on 20/04/2026.
//

#if os(macOS)
import SwiftUI
import AppKit

struct ReportFormViewMacOS: View {
    @Environment(\.dismiss) private var dismiss

    @State private var bugUIImages = [NSImage]()
    @State private var files = [URL]()
    @State private var text = ""
    @State private var showTextError = false
    @State private var isLoading = false
    @State private var showSuccessErrorView: ViewState?
    @Binding var showReportForm: Bool
    var onDismissWindow: (() -> Void)?

    var authorId: String?
    var type: ReportType

    private var isBugReport: Bool {
        type == .bug
    }

    private var isCharacterLimitReached: Bool {
        text.count > 500
    }

    var body: some View {
        VStack(spacing: 16) {
            if let showSuccessErrorView = showSuccessErrorView {
                SuccessErrorView(state: showSuccessErrorView, onDismiss: {
                    dismiss()
                })
            } else if isLoading {
                SendingView()
            } else {
                titleAndBackButton()
                imagePicker()
                addDescription()
                Spacer()
            }
        }
        .padding()
    }

    private func sendRequestValidation() {
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
            let result = try await SpyBugService().createBugReport(
                reportIn: ReportCreate(description: text, type: type, authorId: authorId)
            )

            if isBugReport && !bugUIImages.isEmpty {
                let imageDataArray = bugUIImages.compactMap { image in
                    image.jpegData(compressionQuality: 0.8)
                }
                if !imageDataArray.isEmpty {
                    _ = try await SpyBugService().addPicturesToCreateBugReport(
                        reportId: result.id,
                        files: imageDataArray
                    )
                }
            }

            if !files.isEmpty {
                do {
                    _ = try await SpyBugService().addFilesToReport(reportId: result.id, files: files)
                } catch {
                    print("Error uploading files: \(error.localizedDescription)")
                }
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
    private func imagePicker() -> some View {
        if isBugReport {
            ReportProblemImagePicker(problemUIImages: $bugUIImages, files: $files)
        }
    }

    @ViewBuilder
    private func titleAndBackButton() -> some View {
        ZStack {
            HStack(alignment: .center) {
                Button {
                    showReportForm = false
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(Color(.secondary))
                        .padding(.horizontal)
                }
                .buttonStyle(.plain)
                Spacer()
            }

            Text(type.shortTitle, bundle: .module)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(.title))

            HStack(alignment: .center) {
                Spacer()
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
                .buttonStyle(.plain)
                .disabled(isCharacterLimitReached)
            }
        }
        .padding(.bottom)
    }

    @ViewBuilder
    private func addDescription() -> some View {
        VStack {
            TextEditor(text: $text)
                .placeholder(when: text.isEmpty) {
                    Text(showTextError ? "This field should not be empty" : "Add a description here...", bundle: .module)
                        .foregroundStyle(showTextError ? .red : Color(.secondary))
                        .font(.system(size: 14, weight: .regular))
                        .padding(.leading, 8)
                }
                .font(.system(size: 18, weight: .regular))
                .frame(height: 180)
                .scrollContentBackground(.hidden)
                .background(Color(.button))
            
            HStack {
                Spacer()
                DescriptionValidation(text: text)
            }
            .offset(x: 4, y: 4)
        }
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

private extension NSImage {
    func jpegData(compressionQuality: CGFloat) -> Data? {
        guard let tiffData = tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        return bitmapRep.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality])
    }
}
#endif
