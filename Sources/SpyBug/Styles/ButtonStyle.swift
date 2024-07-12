//
//  ButtonStyle.swift
//
//
//  Created by Pavel Kurzo on 19/12/2023.
//

import SwiftUI

let spyBugGradient: LinearGradient = .linearGradient(
    colors: [Color(.linearOrange), Color(.linearRed)],
    startPoint: .leading,
    endPoint: .trailing
)

public struct ReportButtonStyle: ButtonStyle {
    var icon: Image
    @Environment(\.colorScheme) var colorScheme
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 16){
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundStyle(Color(.secondary))
            configuration.label
                .font(.system(size: 18))
                .foregroundStyle(Color(.secondary))
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 12, height: 21)
                .foregroundStyle(Color(.secondary))
                .padding(.trailing)
        }
        .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 8))
        .frame(height: 69)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.button))
                .shadow(color: Color(.shadow), radius: 4)
        )
    }
}
