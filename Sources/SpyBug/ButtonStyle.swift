//
//  SwiftUIView.swift
//  
//
//  Created by Pavel Kurzo on 19/12/2023.
//

import SwiftUI

public struct ReportBugButtonStyle: ButtonStyle {
    
    public static var defaultStyle: ReportBugButtonStyle {
        return ReportBugButtonStyle()
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 69)
            .padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 8))
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.25), radius: 4)
            )
            .padding(.horizontal)
    }
}
