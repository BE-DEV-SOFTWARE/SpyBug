//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 19/12/2023.
//

import SwiftUI

public struct ReportButtonStyle: ButtonStyle {
    var icon: Image
    @Environment(\.colorScheme) var colorScheme

    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 16){
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .colorMultiply(colorScheme == .light ? Color.gray.opacity(0.8) : Color.white.opacity(0.8))
            configuration.label
                .font(.system(size: 18))
                .foregroundStyle(colorScheme == .light ? .black.opacity(0.8) : .white.opacity(0.8))
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 12, height: 21)
                .foregroundStyle(colorScheme == .light ? .black.opacity(0.6) : .white.opacity(0.6))
                .padding(.trailing)
        }
        .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 8))
        .frame(height: 69)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .light ? .white : .black)
                .shadow(color: colorScheme == .light ? .gray.opacity(0.25) : .white.opacity(0.45), radius: 4)
        )
        .padding(.horizontal)
    }
}
