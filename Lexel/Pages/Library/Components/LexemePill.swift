//
//  LexemePill.swift
//  Lexel
//
//  Created by Tyler McCormick on 6/22/24.
//

import SwiftUI

struct LexemePill: View {
    let text: String
    
    var body: some View {
         Text(text)
            .font(.caption)
            .bold()
            .padding(8)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            
    }
}

#Preview {
    LexemePill(text: "laufen")
}
