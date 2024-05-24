//
//  ChatsMessageCell.swift
//  featrrrnew
//
//  Created by Buddie Booking on 8/10/23.
//

import SwiftUI
import Kingfisher

struct TextualMessageView: View {
    let message: Message
    let user: User
    
    
    private var isFromCurrentUser: Bool {
        return message.isFromCurrentUser
    }
    
    var body: some View {
        HStack {
            
            if isFromCurrentUser {
                Spacer()
                if let url = message.imageUrl {
                    Button(action: {
                        NotificationCenter.default.post(name: NSNotification.PhotoTap, object: url, userInfo: nil)
                    }) {
                        KFImage(URL(string: url))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 120, height: 210)
                            .cornerRadius(.cornerS)
                    }
                        
                } else if let urls = message.imageUrls {
                    Button(action: {
                        NotificationCenter.default.post(name: NSNotification.PhotoTap, object: urls, userInfo: nil)
                    }) {
                        ImageCarousel(urls: urls)
                            .minified()
                            .messageBadge(number: urls.count, alignment: .leading)
                            .padding(.top, .sm) //Compensate for the urls
                    }
                } else if message.type == .audio, let path = message.url, let url = URL(string: path) {
                    
                    AudioMessageView(isFromCurrentUser: isFromCurrentUser,  backgroundColor: .primary, audioViewModel: AudioMessageSharedViewModel(audioMessage: AudioMessage(path: url, duration: message.duration), foregroundColor: Color.background, sampleCount: 30))
                    
                } else if message.type == .proposal, let proposalID = message.proposalID {
                    NavigationLink(destination: PaymentView(paymentViewModel: PaymentViewModel(selectedProposalID: proposalID))) {
                        ProposalMessageView(viewModel: ProposalMessageViewModel(currentUser: isFromCurrentUser, id: proposalID))
                    }
                    
                } else {
                    SmartText(message.text)
                        .font(Style.font.messageBody)
                        .background(Color.primary)
                        .foregroundColor(Color.background)
                        .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
                }
            } else {
                HStack(alignment: .bottom, spacing: CGFloat.sm) {
                    CircularProfileImageView(user: user)
                    
                    if let url = message.imageUrl {
                        Button(action: {
                            NotificationCenter.default.post(name: NSNotification.PhotoTap, object: url, userInfo: nil)
                        }) {
                            KFImage(URL(string: url))
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .frame(width: 120, height: 210)
                                .cornerRadius(.cornerS)
                        }
                            
                    } else if let urls = message.imageUrls {
                        Button(action: {
                            NotificationCenter.default.post(name: NSNotification.PhotoTap, object: urls, userInfo: nil)
                        }) {
                            ImageCarousel(urls: urls)
                                .minified()
                                .messageBadge(number: urls.count, alignment: .leading)
                                
                        }
                    } else if message.type == .audio, let path = message.url, let url = URL(string: path) {
                        
                        AudioMessageView(isFromCurrentUser: isFromCurrentUser,  backgroundColor: Color.lightBackground, audioViewModel: AudioMessageSharedViewModel(audioMessage: AudioMessage(path: url, duration: message.duration), foregroundColor: Color.background, sampleCount: 30))
                        
                    } else if message.type == .proposal, let proposalID = message.proposalID {
                        
                        ProposalMessageView(viewModel: ProposalMessageViewModel(currentUser: isFromCurrentUser, id: proposalID))
                            .notCurrentUserColoring()
                        
                    } else {
                        SmartText(message.text)
                            .font(Style.font.messageBody)
                            .background(Color.lightBackground)
                            .foregroundColor(Color.background)
                            .clipShape(ChatBubble(isFromCurrentUser: isFromCurrentUser))
                            .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .leading)
                    }
                    Spacer()
                }
            }
        }
        .padding(.horizontal, .sm)

    }
}
