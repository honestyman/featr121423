//
//  Message.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import FirebaseFirestoreSwift
import Firebase

enum MessageSendType {
    case text(String)
    case image([UIImage])
    case link(String)
    case audio(AudioMessage)
    case proposal(String) //With document ID
}

enum MessageType: String, Codable {
    case textOrLink, image, audio, proposal
}

enum ContentType {
    case text(String)
    case image([String])
    case link(String)
    case audio(String)
}

struct Message: Identifiable, Codable, Hashable {
    @DocumentID var messageId: String?
    let fromId: String
    let toId: String
    let text: String
    let type: MessageType?
    let timestamp: Timestamp
    var user: User?
    var read: Bool
    var url: String?
    var duration: String?
    var imageUrls: [String]?
    var imageUrl: String? {
        didSet {
            if let imageUrl = imageUrl {
                imageUrls = [imageUrl]
            }
        }
    }
    let proposalID: String?
    
    var id: String {
        return messageId ?? NSUUID().uuidString
    }
    
    var chatPartnerId: String {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid
    }
    
    var isImageMessage: Bool {
        return url != nil
    }
    
    var contentType: ContentType {
        
        if let url = url {
            switch (type) {
            case .audio:
                return .audio(url)
            default:
                if let imageUrl = imageUrl {
                    return .image([imageUrl])
                }
            }
            
            if text.hasPrefix("http") {
                return .link(text)
            }
            
        }
        return .text(text)
    }
}
    

struct Conversation: Identifiable, Hashable, Codable {
    @DocumentID var conversationId: String?
    let lastMessage: Message
    var firstMessageId: String?
    
    var id: String {
        return conversationId ?? NSUUID().uuidString
    }
}

struct AudioMessage {
    var path: URL
    var duration: String?
    init(path: URL, duration: String?) {
        self.path = path
        self.duration = duration
    }
}
