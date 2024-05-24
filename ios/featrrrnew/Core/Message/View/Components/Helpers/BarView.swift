//
//  BarView.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/25/24.
//

import SwiftUI

struct BarView: View {
    let value: CGFloat
    var color: Color = Color.foreground
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .cornerRadius(.cornerXS)
                .frame(width: 3, height: value)
        }
    }
}
