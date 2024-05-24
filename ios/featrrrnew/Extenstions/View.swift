//
//  View.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/19/24.
//

import Foundation
import SwiftUI

struct UpsideDown: ViewModifier {
    func body(content: Content) -> some View {
        return content.rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
    }
}

struct FeatrTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Style.font.caption)
            .background(Color.lightBackground)
            .cornerRadius(.cornerS)
    }
}

extension View {
    func upsideDown() -> some View {
        return modifier(UpsideDown())
    }
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}



struct OnlyNumericInput<T: LosslessStringConvertible>: ViewModifier {
    @Binding var value: T?
    @Binding var text: String

    func body(content: Content) -> some View {
        content
            .onChange(of: text, perform: { newValue in
                if newValue == "" {
                    value = nil
                } else if T(newValue) == nil {
                    if let value {
                        if text != String(value) {
                            text = String(value)
                        }
                    } else {
                        text = ""
                    }
                } else {
                    value = T(newValue)
                }
            })
    }
}

extension TextField {
    func onlyNumeric<T: LosslessStringConvertible>(_ text: Binding<String>, numberStorage: Binding<T?>) -> some View {
        self.modifier(OnlyNumericInput<T>(value: numberStorage, text: text))
    }
}
