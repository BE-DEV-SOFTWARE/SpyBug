//
//  ReportOptionsView 2.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI

@available(iOS 15.0, *)
struct ReportOptionsView: View {
    @State var isShowing = false
    let imagePath = Bundle.main.path(forResource: "bugRegular", ofType: "png")
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Need help?")
                .font(.system(size: 24, weight: .bold))
                .padding(.vertical, 10)
            NavigationLink { RequestView(title: "Report a problem", buttonText: "Send request", isOpenForReportAProblem: true) } label: {
                ReportOptionRow(icon: "bug-regular", text: "Report a problem")
            }
            NavigationLink { RequestView(title: "Request improvement", buttonText: "Send request") } label: {
                ReportOptionRow(icon: "rocket-launch-regular", text: "Request improvement")
            }
            NavigationLink { RequestView(title: "Ask question", buttonText: "Send request") } label: {
                ReportOptionRow(icon: "circle-question-regular", text: "Ask question")
            }
            NavigationLink { RequestView(title: "Request a feature", buttonText: "Send request") } label: {
                ReportOptionRow(icon: "wand-magic-sparkles-regular", text: "Request a feature")
            }
            Spacer()
        }
    }
}

@available(iOS 15.0, *)
struct ReportOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReportOptionsView()
        }
    }
}

@available(iOS 15.0, *)
private struct ReportOptionRow: View {
    var icon: String
    var text: LocalizedStringKey
    
    var body: some View {
        HStack(spacing: 16){
            Image(packageResource: icon, ofType: "png")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .colorMultiply(Color.gray.opacity(0.8))
            Text(text)
                .font(.system(size: 18))
                .foregroundStyle(.black.opacity(0.8))
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 12, height: 21)
                .foregroundStyle(.black.opacity(0.6))
                .padding(.trailing)
        }
        .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 8))
        .frame(height: 69)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.25), radius: 4)
        )
        .padding(.horizontal)
    }
}
