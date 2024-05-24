//
//  BadgeModifier.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/6/24.
//

import SwiftUI

// Adapted from ChatGPT
struct BadgeModifier: ViewModifier {
    var number: Int
    var alignment: MessageBadgeAlignment
    
    func body(content: Content) -> some View {
        ZStack(alignment: alignment == .leading ? .topLeading : .topTrailing) {
            content
            
            Text("\(number)")
                .padding(6)
                .frame(width: 30, height: 30)
                .minimumScaleFactor(0.5)
                .background(Color.primary)
                .foregroundColor(.background)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.background, lineWidth: 2)
                        .frame(width: 30, height: 30)
                )
                .offset(x: alignment == .leading ? -15 : 15, y: -15)
        }
    }
}
enum MessageBadgeAlignment {
    case leading, trailing
}
extension View {
    func messageBadge(number: Int, alignment: MessageBadgeAlignment) -> some View {
        self.modifier(BadgeModifier(number: number, alignment: alignment))
    }
}
