//
//  Text.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/22/24.
//

import Foundation
import SwiftUI

extension Text {
    func notEmptyJobfix(_ jobfix: String) -> Text {
        if self == Text.empty() {
            return self
        }
        
        return self + Text(jobfix)
    }
    
    static func empty() -> Text {
        return Text("")
    }
}
