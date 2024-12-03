//
//  SuccessErrorView.swift
//
//
//  Created by Szymon Wnuk on 11/07/2024.
//

import SwiftUI
import AdaptiveSheet

enum ViewState: Equatable {
    case error
    case success(reportType: ReportType)
    
    var icon: Image {
        switch self {
        case .error:
#if os(visionOS)
            return Image(.pinkFace)
#else
            return Image(.errorEmoji)
#endif
            
        case .success(let reportType):
            return reportType.greenSuccessIcon
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .error:
            "Oh no!"
        case .success:
            "It’s sent!"
        }
    }
    
    var viewText: LocalizedStringKey {
        switch self {
        case .error:
            "Your request couldn't be sent. Our spies probably overlooked one bug here...\nPlease try again later."
        case .success:
            "We successfully received your request.  Our team will take it into account as soon as possible. "
        }
    }
    
    var buttonText: LocalizedStringKey {
        switch self {
        case .error:
            "Close"
        case .success:
            "Thank you!"
        }
    }
}

struct SuccessErrorView: View {
    @Environment(\.adaptiveDismiss) private var dismiss
    var state: ViewState
    
    var body: some View {
        VStack(spacing: 20) {
            state.icon
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .padding(.top, 80)
            Text(state.title, bundle: .module)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(state == .error ? Color(.yourPink) : Color.primary)
            Text(state.viewText, bundle: .module)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(Color(.graySuccess))
                .lineSpacing(5)
            Spacer()
            Button {
                dismiss()
            } label: {
                HStack{
                    Spacer()
                    Text(state.buttonText, bundle: .module)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.primary)
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color(.doveGray))
                )
            }
        }
    }
}

struct SuccessErrorViewVisionOS: View {
    var state: ViewState
#if os(visionOS)
    @Environment(\.dismissWindow) private var dismissWindow
#endif
    
    var body: some View {
        VStack(spacing: 70) {
            state.icon
                .resizable()
                .scaledToFit()
                .frame(height: 180)
                .padding(.top, 80)
            VStack(spacing: 20){
                Text(state.title, bundle: .module)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(state == .error ? Color(.yourPink) : Color.primary)
                Text(state.viewText, bundle: .module)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(Color(.graySuccess))
                    .lineSpacing(5)
                Button {
#if os(visionOS)
                    dismissWindow()
#endif
                } label: {
                    HStack{
                        Spacer()
                        Text("Thank you", bundle: .module)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(Color.primary)
                        Spacer()
                    }
                    .padding()
                    .frame(height: 55)                    
                }
                .padding(.top, 25)

            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview("Success") {
    SuccessErrorView(state: .success(reportType: .bug))
}

#Preview("Fail") {
    SuccessErrorView(state: .error)
}
