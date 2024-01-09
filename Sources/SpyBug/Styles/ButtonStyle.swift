//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 19/12/2023.
//

import SwiftUI

public struct ReportButtonStyle: ButtonStyle {
    var icon: Image
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 16){
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .colorMultiply(Color.gray.opacity(0.8))
            configuration.label
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
