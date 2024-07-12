//
//  ReportOptionsView 2.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI

@available(iOS 15.0, *)
struct ReportOptionsView: View {
    @Environment(\.openURL) private var openURL
    var apiKey: String
    var author: String?
    @State private var selectedType: ReportType?
    @State private var showReportForm = false
    
    var body: some View {
        VStack {
            if !showReportForm {
                VStack(spacing: 16) {
                    Text("Need help?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.titleColor)
                        .padding(.vertical, 10)
                    
                    ForEach(ReportType.allCases, id: \.self) { type in
                        ReportOptionRow(type: type)
                        
                    }
                    Spacer()
                    PoweredBySpybug()
                }
                .background(Color.backgroundColor)
                .transition(.move(edge: .leading))
            } else {
                if let selectedType {
                    ReportFormView(
                        showReportForm: $showReportForm,
                        apiKey: apiKey,
                        author: author,
                        type: selectedType
                    )
                    .transition(.move(edge: .trailing))
                }
            }
            
        }
        
    }
    
    
    @ViewBuilder
    private func PoweredBySpybug() -> some View {
        let urlString = "https://www.spybug.io/"
        let textColor = Color(.poweredBy)
        
        HStack{
            VStack(alignment: .leading, spacing: 5){
                HStack{
                    Text("Powered by")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(textColor)
                    Button{
                        guard let url = URL(string: urlString) else { return }
                        openURL(url)
                    } label: {
                        Text("SpyBug")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.linearGradient(colors: [.linearOrange, .linearRed], startPoint: .leading, endPoint: .trailing))
                    }
                    
                }
                Text("All right reserved 2024")
                    .font(.system(size: 12))
                    .foregroundStyle(textColor)
            }
            Spacer()
            Image(.spyBugLogo)
                .aspectRatio(contentMode: .fit)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func ReportOptionRow(type: ReportType) -> some View {
        Button(type.title) {
            withAnimation {
                showReportForm = true
            }
            selectedType = type
        }
        .buttonStyle(ReportButtonStyle(icon: type.icon))
    }
}

@available(iOS 15.0, *)
struct ReportOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportOptionsView(apiKey: "", author: "John Doe")
            .preferredColorScheme(.dark)
    }
}

