//
//  Chip.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/25/24.
//

import SwiftUI

enum ChipStyle {
    case information, cancel, success, pending
}
struct Chip: View {
    
    private let style: ChipStyle
    private let text: String
    private let backgroundColor: Color
    
    init(text: String, style: ChipStyle) {
        self.style = style
        self.text = text
        switch (style) {
        case .information:
            backgroundColor = Color.primary
        case .cancel:
            backgroundColor = Color.warning
        case .success:
            backgroundColor = Color.success
        case .pending:
            backgroundColor = Color.lightBackground
        }
    }
    var body: some View {
        VStack {
            
            Text(text)
                .foregroundColor(.background)
                .padding()
                .minimumScaleFactor(0.8)
                .font(Style.font.body2)
        }
        .frame(height: 26)
        .background(backgroundColor)
        .cornerRadius(.cornerM)
    }
}

#Preview {
    Chip(text: "TEST CHIP", style: .information)
}
