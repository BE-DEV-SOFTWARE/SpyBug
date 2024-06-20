//
//  ReportOptionsView 2.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI

@available(iOS 15.0, *)
struct ReportOptionsView: View {
    @Environment(\.colorScheme) var colorScheme

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
        }
        .background(Color.backgroundColor)
        
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

