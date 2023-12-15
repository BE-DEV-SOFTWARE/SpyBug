//
//  RequestView.swift
//
//
//  Created by Pavel Kurzo on 13/12/2023.
//

import SwiftUI

@available(iOS 15.0, *)
struct RequestView: View {
    
    //TODO: What user should be able to pass using this package
    // 5. We want user to be able provide images

    
    
    // camera image gray
    // button styly optional to pass, default to normal button
    // api key to pass
    // author id to pass
    // 3 last screens should have text, not optional!
    // show the sheet when shaking the phone
    
    
    @Environment(\.dismiss) private var dismiss
    @State private var problemsUIImages = [UIImage]()
    @State private var text = ""
    var title: LocalizedStringKey = ""
    var buttonText: LocalizedStringKey = ""
    var isOpenForReportAProblem = false
    @State var isShowingXmark = false
    
    var body: some View {
            VStack {
                TitleAndBackButton()
                
                ImagePicker()
                
                Text(isOpenForReportAProblem ? "Add comment" : "Add description")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                AddDescription()
                
                Spacer()
                
                
                Button {} label: {
                    Text(buttonText)
                }
//                .buttonStyle(Primary(isGradient: true))
            }
            .frame(height: 450)
            .navigationBarHidden(true)
            .padding()
            .background(Color.white.opacity(0.1))
            .onTapGesture {
                isShowingXmark.toggle()
            }
    }
    
    @ViewBuilder
    private func ImagePicker() -> some View {
        if isOpenForReportAProblem {
            VStack {
                Text("Add screenshots")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                ReportProblemImagePicker(problemUIImages: $problemsUIImages, isShowingXmark: $isShowingXmark)
            }
        }
    }
    
    @ViewBuilder
    private func TitleAndBackButton() -> some View {
        HStack(alignment: .center) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                .font(.system(size: 28, weight: .regular))
                .foregroundStyle(.black.opacity(0.6))
                    .padding(.leading)
            }
            Spacer()
            Text(title)
                .font(.system(size: 24, weight: .bold))
            
            Spacer()
        }
        .frame(height: 36)
        .padding(.bottom)
        .buttonStyle(.plain)
    }
    
    @available(iOS 15.0, *)
    @ViewBuilder
    private func AddDescription() -> some View {
        ZStack {
            if text.isEmpty {
                VStack {
                    HStack {
                        Text("Type here...")
                            .foregroundStyle(.black.opacity(0.7))
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
        .frame(height: isOpenForReportAProblem ? 50 : 200)
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .cornerRadius(25, corners: .allCorners)
                .shadow(color: .black.opacity(0.15), radius: 5)
        )
    }
}

@available(iOS 15.0, *)
struct RequestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RequestView(isOpenForReportAProblem: true)
        }
    }
}
