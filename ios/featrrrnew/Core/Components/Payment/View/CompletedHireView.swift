//
//  CompletedHireView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/8/23.
//

import SwiftUI

struct CompletedHireView: View {
    var body: some View {
        VStack{
            
            
            
            Text("CONGRATULATIONS YOU HAVE A")
            
            Image("featrlogo")
                .resizable()
                .scaledToFit()
                .frame(width: 700, height: 500)
        }
    }
}

struct CompletedHireView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedHireView()
    }
}
