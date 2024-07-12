//
//  SuccessErrorView.swift
//
//
//  Created by Szymon Wnuk on 11/07/2024.
//

import SwiftUI

enum ViewState {
    case error
    case success
    
    var icon: Image{
        
        switch self {
        case .error:
            Image(.errorEmoji)
        case .success:
            Image(.greenRocket)
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
            "This report couldn't be sent. Our spies probably overlooked one bug here...\nPlease try again later."
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
    @Environment(\.dismiss) private var dismiss
    var state: ViewState
    
    var body: some View {
        VStack(spacing: 20){
            state.icon
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .padding(.top, 80)
            Text(state.title)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(state == .error ? Color(.yourPink) : Color.primary)
            Text(state.viewText)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(Color(.graySuccess))
                .lineSpacing(5)
            Spacer()
            Button {
                dismiss()
            }
            label: {
                HStack{
                    Spacer()
                    Text(state.buttonText)
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

#Preview("Success") {
    SuccessErrorView(state: .success)
}

#Preview("Fail") {
    SuccessErrorView(state: .error)
}
