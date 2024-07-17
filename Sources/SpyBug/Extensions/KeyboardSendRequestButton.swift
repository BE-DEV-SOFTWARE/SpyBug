//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 17/07/2024.
//

import SwiftUI

struct KeyboardSendRequestButton: ViewModifier {
    var action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack(spacing: 16) {
                        Text("Send request", bundle: .module)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color.white)
                        
                        Image(systemName: "paperplane")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 35)
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(spyBugGradient)
                            .shadow(color: Color(.shadow), radius: 4)
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .onTapGesture {
                        action()
                    }
                }
            }
    }
}
