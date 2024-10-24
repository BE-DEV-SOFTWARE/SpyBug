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
    var reportTypes: [ReportType]
    
    let id = "ReportOptionsView"
    
    public init(showReportForm: Bool = false, author: String? = nil, reportTypes: [ReportType]) {
        self.showReportForm = showReportForm
        self.author = author
        self.reportTypes = reportTypes
        
    }
    
    public var body: some View {
        VStack {
            if !showReportForm {
                
                
                VStack(spacing: 16) {
                    
                    HStack(alignment: .center) {
#if os(visionOS)
                        Button {
                            KeyboardUtils.hideKeyboard()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 28, weight: .regular))
                                .foregroundStyle(Color(.secondary))
                                .padding(.leading)
                        }
                        .buttonStyle(.plain)
#endif
                        Spacer()
                        
                        Text("Need help?", bundle: .module)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(Color(.title))
                            .padding(.vertical, 10)
                        
                        Spacer()
                    }
#if os(visionOS)
                    .padding(.top, 10)
#endif
                    ForEach(reportTypes, id: \.self) { type in
                        ReportOptionRow(type: type)
                    }
                    Spacer()
                    PoweredBySpybug()
                }
                .padding(.horizontal)
                .transition(.move(edge: .leading))
            } else {
                if let selectedType {
                    ReportFormView(
                        showReportForm: $showReportForm,
                        author: author,
                        type: selectedType
                    )
                    .transition(.move(edge: .trailing))
                }
            }
        }
        .background(Color(.background))
#if os(visionOS)
        .padding(.bottom)
#endif
    }
    
    @ViewBuilder
    private func PoweredBySpybug() -> some View {
        let urlString = "https://www.spybug.io/"
        let textColor = Color(.poweredBy)
        
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Powered by", bundle: .module)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(textColor)
                    Button {
                        guard let url = URL(string: urlString) else { return }
                        openURL(url)
                    } label: {
                        Text("SpyBug", bundle: .module)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(spyBugGradient)
                    }
                    .buttonStyle(.plain)
                }
                Text("All rights reserved 2024", bundle: .module)
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
                showReportForm = true
                selectedType = type
            }
        } label: {
            Text(type.title, bundle: .module)
        }
        .buttonStyle(ReportButtonStyle(icon: type.icon))
    }
}


struct ReportOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportOptionsView(author: "John Doe", reportTypes: ReportType.allCases)
            .preferredColorScheme(.dark)
            .background(Color(.background))
    }
}

