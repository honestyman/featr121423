//
//  CustomTextField.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

//  Created by Stephen Dowless on 12/27/20.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(.sm)
            .background(Color.field)
            .cornerRadius(.cornerS)
            .padding(.horizontal, .lg)
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Style.font.title4)
            .padding(.sm)
            .background(Color.field)
            .cornerRadius(.cornerS)
            .padding(.horizontal, .lg)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(text: .constant(""), placeholder: "Email")
    }
}
