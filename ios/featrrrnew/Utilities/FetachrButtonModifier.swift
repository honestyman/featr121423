//
//  FetachrButtonModifier.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import Foundation

import SwiftUI

struct FeatchrButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Style.font.caption)
            .foregroundColor(Color.background)
            .frame(width: 360, height: 44)
            .background(Color.primary)
            .cornerRadius(.cornerS)
            .padding()
    }
}
