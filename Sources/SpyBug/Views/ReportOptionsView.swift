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
    
    public init(showReportForm: Bool = false, author: String? = nil, reportTypes: [ReportType] = ReportType.allCases) {
        self.showReportForm = showReportForm
        self.author = author
        self.reportTypes = reportTypes
    }
    
    public var body: some View {
        VStack {
            if !showReportForm {
                VStack(spacing: 16) {
                    PlatformView()
                    .transition(.move(edge: .leading))}
            } else {
                if let selectedType {
#if iOS
                    ReportFormView(
                        showReportForm: $showReportForm,
                        author: author,
                        type: selectedType
                            .transition(.move(edge: .trailing))
                    )
#elseif os(visionOS)
                    ReportFormViewVisionOS(
                        showReportForm: $showReportForm,
                        author: author,
                        type: selectedType)
                    .transition(.move(edge: .trailing))
#endif
                    
                }
            }
        }
        
    }
    
    
    @ViewBuilder
    private func PlatformView() -> some View {
#if os(visionOS)
        VisionOSReportOptionsView()
#elseif os(iOS)
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
        .background(Color(.background))
        .padding(.horizontal)
    }
    
#if os(visionOS)
    private func VisionOSReportOptionsView() -> some View {
        VStack(spacing: 16) {
            HStack(alignment: .center) {
                
                Image(.bugSolid)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(5)
                    .background(Circle()
                        .foregroundStyle(.black.opacity(0.2))
                    )
                
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
    } #endif
    
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
    
    @ViewBuilder
    private func ReportOptionRowVisionOS(type: ReportType) -> some View {
        Button {
            withAnimation{
                showReportForm = true
                selectedType = type}
        } label: {
            Text(type.title, bundle: .module)
        } .buttonStyle(VisionOSReportButtonStyle(icon: type.icon))
    }
}

struct ReportOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportOptionsView(author: "John Doe")
            .preferredColorScheme(.dark)
            .background(Color(.background))
    }
}
