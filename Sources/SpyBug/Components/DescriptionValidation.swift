//
//  SwiftUIView.swift
//  SpyBug
//
//  Created by Pavel Kurzo on 27/09/2024.
//

import SwiftUI

struct DescriptionValidation: View {
    var text = ""
    
    var body: some View {
        let characterCount = text.count
        let isOverLimit = characterCount > 500
        
         HStack {
            Text("\(characterCount) / 500")
                .font(.system(size: 12))
                .foregroundStyle(isOverLimit ? .red : Color(.darkBrown))
        }
    }
}

#Preview {
    DescriptionValidation()
}
