//
//  SendingView.swift
//
//
//  Created by Szymon Wnuk on 11/07/2024.
//

import SwiftUI

struct SendingView: View {
    var body: some View {
        VStack(spacing: 70) {
            Spacer()
            ProgressView()
                .tint(Color(.yellowOrange))
                .controlSize(.large)
                .frame(width: 40, height: 40)
                
            VStack(spacing: 20){
                Text("Sending..." , bundle: .module)
                    .foregroundStyle(Color(.yellowOrange))
                    .font(.system(size: 32, weight: .bold))
                Text("Our spies need a moment, please wait for your request to be sent.", bundle: .module)
                    .foregroundStyle(Color(.poweredBy))
                    .font(.system(size: 18, weight: .regular))
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SendingView()
}
