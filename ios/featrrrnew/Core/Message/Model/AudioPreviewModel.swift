//
//  AudioPreviewModel.swift
//  featrrrnew
//
//  Created by Josh Beck on 2/28/24.
//

import Foundation
import SwiftUI

struct AudioPreviewModel: Identifiable, Hashable {
    var id: Int
    var magnitude: Float?
    var color: Color
    
    init(magnitude: Float?, color: Color, id: Int? = nil) {
        if let id = id {
            self.id = id
        } else {
            self.id = Int.random(in: 0...Int.max)
        }
        self.magnitude = magnitude
        self.color = color
    }
}
