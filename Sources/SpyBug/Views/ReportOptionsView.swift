//
//  ReportOptionsView 2.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI

public struct ReportOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
#if os(visionOS)
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openWindow) private var openWindow
#endif
    var author: String?
    @State private var selectedType: ReportType?
    @State private var showReportForm = false
    let year = String(Calendar.current.component(.year, from: Date()))
    var reportTypes: [ReportType]
    var onClose: (() -> Void)?

    public init(
        showReportForm: Bool = false,
        author: String? = nil,
        reportTypes: [ReportType] = ReportType.allCases,
        onClose: (() -> Void)? = nil
    ) {
        self.showReportForm = showReportForm
        self.author = author
        self.reportTypes = reportTypes
        self.onClose = onClose
    }

    public var body: some View {
        VStack(spacing: 16) {
            PlatformView()
        }
        .navigationDestination(isPresented: $showReportForm) {
            if let selectedType {
#if os(iOS)
                ScrollView {
                    ReportFormView(
                        showReportForm: $showReportForm,
                        authorId: author,
                        type: selectedType,
                        onDismissSheet: {
                            dismiss()
                        }
                    )
                }
                .clearHostingBackground()
#elseif os(macOS)
                ScrollView {
                    ReportFormViewMacOS(
                        showReportForm: $showReportForm,
                        authorId: author,
                        type: selectedType
                    )
                }
                .navigationBarBackButtonHidden()
#elseif os(visionOS)
                ReportFormViewVisionOS(
                    showReportForm: $showReportForm,
                    author: author,
                    type: selectedType,
                    onDismissWindow: {
                        dismissWindow()
                    }
                )
                .navigationBarBackButtonHidden()
#endif
            }
        }
    }
    
    @ViewBuilder
    private func PlatformView() -> some View {
#if os(visionOS)
        VisionOSReportOptionsView()
#elseif os(iOS) || os(macOS)
        iOSReportOptionsView()
#endif
    }

    @ViewBuilder
    private func iOSReportOptionsView() -> some View {
        VStack(spacing: 16) {
            Text("Need help?", bundle: .module)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(.title))
                .padding(.vertical, 10)

            ForEach(reportTypes, id: \.self) { type in
                ReportOptionRow(type: type)
            }

            Spacer()
            PoweredBySpybug()
        }
        .padding(.horizontal)
        .overlay {
#if os(macOS)
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        closeMacSheet()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background {
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                            }
                    }
                    .buttonStyle(.plain)
                }
                .offset(y: -5)
                Spacer()
            }
            .padding()
#endif
        }
    }
    
#if os(visionOS)
    private func VisionOSReportOptionsView() -> some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                Spacer()

                Text("Need help?", bundle: .module)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(.title))
                    .padding(.vertical, 10)

                Spacer()
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)

            ForEach(reportTypes, id: \.self) { type in
                ReportOptionRowVisionOS(type: type)
            }

            Spacer()
            PoweredBySpybug()
        }
        .padding(.bottom)
        .padding(.horizontal)
        .glassBackgroundEffect()
    }
#endif

    @ViewBuilder
    private func PoweredBySpybug() -> some View {
        let textColor = Color(.poweredBy)

        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Powered by", bundle: .module)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(textColor)
                    Button {
                        openURL(Constant.presentationWebsiteURL)
                    } label: {
                        Text("SpyBug", bundle: .module)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(spyBugGradient)
                    }
                    .buttonStyle(.plain)
                }
                Text("All rights reserved \(year)", bundle: .module)
                    .font(.system(size: 12))
                    .foregroundStyle(textColor)
            }
            Spacer()
            Image(.spyBugLogo)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
        }
    }

    @ViewBuilder
    private func ReportOptionRow(type: ReportType) -> some View {
        Button {
            withAnimation {
                selectedType = type
                showReportForm = true
            }
        } label: {
            Text(type.title, bundle: .module)
        }
        .buttonStyle(ReportButtonStyle(icon: type.icon))
    }

#if os(macOS)
    private func closeMacSheet() {
        showReportForm = false
        onClose?()
        dismiss()
    }
#endif

#if os(visionOS)
    @ViewBuilder
    private func ReportOptionRowVisionOS(type: ReportType) -> some View {
        Button {
            withAnimation{
                selectedType = type
                showReportForm = true
            }
        } label: {
            Text(type.title, bundle: .module)
        } .buttonStyle(VisionOSReportButtonStyle(icon: type.icon))
    }
#endif
}

struct ReportOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReportOptionsView(author: "John Doe")
                .preferredColorScheme(.dark)
                .background(Color(.background))
        }
    }
}
