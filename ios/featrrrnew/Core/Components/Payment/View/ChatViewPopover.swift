//
//  ChatViewPopover.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/20/24.
//

import SwiftUI

struct ChatViewPopover: View {
    @Environment(\.dismiss) private var dismiss
    let user: User
    var body: some View {
        NavigationView {
            ChatsView(user: user)
                .navigationTitle("Edit Portfolio")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Dismiss")
                        })
                    }
                })
        }
        
    }
}
