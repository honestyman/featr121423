//
//  UIApplication.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/22/24.
//

import UIKit
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
