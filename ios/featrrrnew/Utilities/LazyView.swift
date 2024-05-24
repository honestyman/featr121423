//
//  LazyView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/28/23.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping() -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}
