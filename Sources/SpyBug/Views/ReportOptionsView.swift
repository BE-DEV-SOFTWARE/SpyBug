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
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Need help?")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.titleColor)
                .padding(.vertical, 10)
            ForEach(ReportType.allCases, id: \.self) { type in
                ZStack {
                    NavigationLink(
                        destination: ReportFormView(apiKey: apiKey, author: author, type: type),
                        tag: type,
                        selection: $selectedType
                    ) { EmptyView() }.hidden()
                    ReportOptionRow(type: type)
                }
            }
            Spacer()
            
            PoweredBySpybug()
        }
        .background(Color.backgroundColor)
        
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
            selectedType = type
        }
        .buttonStyle(ReportButtonStyle(icon: type.icon))
    }
}

@available(iOS 15.0, *)
struct ReportOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReportOptionsView(apiKey: "", author: "John Doe")
        }
        .preferredColorScheme(.dark)
    }
}

