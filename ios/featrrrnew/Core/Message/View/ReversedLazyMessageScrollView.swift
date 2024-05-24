//
//  ReversedLazyMessageScrollView.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/22/24.
//

import Foundation
import SwiftUI

struct ReversedLazyMessageScrollView: View {
    
    @Binding var messages: [Message]
    @State var isAwaitingRendering = true
    let user: User
    
    var header: some View {
        VStack {
            CircularProfileImageView(user: user)
            
            VStack(spacing: CGFloat.xxsm) {
                Text(user.username)
                    .font(Style.font.title3)
                    .fontWeight(.semibold)
                
                Text("Messenger")
                    .font(Style.font.messageBody)
                    .foregroundColor(Color.lightBackground)
            }
        }
        
    }
    
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(messages.reversed()) { message in
                        TextualMessageView(message: message, user: user)
                            .upsideDown()
                            .onAppear {
                                isAwaitingRendering = false //As soon as any item appears, we have started rendering
                            }
                    }
                }
                
                if isAwaitingRendering {
                    ProgressView()
                }
                header.upsideDown()
                .padding(.vertical)
            }.upsideDown()
            .onChange(of: messages) { newValue in
                guard  let lastMessage = newValue.last else { return }
        
                withAnimation(.spring()) {
                    proxy.scrollTo(lastMessage.id)
                }
            }
        }
    }
}
    
