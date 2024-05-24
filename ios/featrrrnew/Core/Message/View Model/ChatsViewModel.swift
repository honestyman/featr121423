//
//  ChatsViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 8/10/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import PhotosUI
import SwiftUI

class ChatsViewModel: ObservableObject {

    private let service: ChatService
    
    @Published var isRecording: Bool = false
    @Published var sendableError: Bool = false
    @Published var showAlert: Bool = false

    @Published var messageImage: Image?
    @Published var audioMessage: AudioMessage?
    
    @Published var playingAudio: Bool = false
    @Published var messageText = ""
    @Published var messages = [Message]()
    
    /// Note: [Temporary variable] Once the items are selected, the images are loaded and this variable is set to empty
    @Published var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            //Condition is necessary to avoid infinite loops as we are setting the setter from the setter
            if !selectedItems.isEmpty {
                Task {
                    await loadImages(withItems: selectedItems)
                    DispatchQueue.main.sync {
                        selectedItems = []
                    }
                }
            }
        }
    }
    @Published var imageItems: [ImageCarouselItem] = []

            
    init(user: User) {
        self.service = ChatService(chatPartner: user)
        observeChatMessages()
    }
    
    func observeChatMessages() {
        service.observeMessages { [weak self] messages in
            guard let self = self else { return }
            self.messages.append(contentsOf: messages)
        }
    }
    
    func togglePlayingAudio() {
        playingAudio = !playingAudio
    }
    
    @MainActor
        func sendMessage(_ messageText: String) async  {
            do {
                sendableError = false
                showAlert = false
                if imageItems.count > 0 {
                    var images: [UIImage] = []
                    for image in imageItems {
                        if let image = image.image {
                            images.append(image)
                        }
                    }
                    try await service.sendMessage(type: .image(images))
                    imageItems = []
                }  else if let audioMessage = audioMessage {
                    self.audioMessage = nil
                    try await service.sendMessage(type: .audio(audioMessage))
                } else {
                    try await service.sendMessage(type: .text(messageText))
                }
            } catch {
                Log.d(error.localizedDescription)
                sendableError = true
                showAlert = true

            
        }
    }
    
    func removeImage(item image: ImageCarouselItem) {
        if let index = imageItems.firstIndex(where: { $0.id == image.id}) {
            imageItems.remove(at: index)
        }
    }
    @MainActor
        func sendMessages(_ messageText: String) async throws {
            if imageItems.count > 0 {
                var images: [UIImage] = []
                for image in imageItems {
                    if let image = image.image {
                        images.append(image)
                    }
                }
                try await service.sendMessage(type: .image(images))
                imageItems = []
            } else {
                try await service.sendMessage(type: .text(messageText))

            }
        }
        
        func updateMessageStatusIfNecessary() async throws {
            guard let lastMessage = messages.last else { return }
            try await service.updateMessageStatusIfNecessary(lastMessage)
        }
        
        func nextMessage(forIndex index: Int) -> Message? {
            return index != messages.count - 1 ? messages[index + 1] : nil
        }
        
        func removeChatListener() {
            service.removeListener()
        }
    }

extension ChatsViewModel {
    
protocol AudioChatViewModel {
    var isRecording: Bool {get set}
    var audioURL: URL? {get set}
    func isAudioStored() -> Bool
    func clearAudioRecording()
}

    func loadImages(withItems items: [PhotosPickerItem]) async {
        var imageI: [ImageCarouselItem] = []
        for item in items {
            guard let data = try? await item.loadTransferable(type: Data.self) else { return }
            guard let image = UIImage(data: data) else { return }
            var imageCarouselItem = ImageCarouselItem(image: image)
            imageI.append(imageCarouselItem)
        }
        self.imageItems = imageI
        
    }
}
    
/*class ChatsViewModel: ObservableObject {
    @Published var messageText = ""
    @Published var messages = [Message]()
    let service: ChatService
    
    
    init(user: User) {
        self.service = ChatService(chatPartner: user)
        observedMessages()
    }
    
    func observedMessages() {
        service.observedMessages() { messages in
            self.messages.append(contentsOf: messages)
        }
    }
    
    func sendMessage() {
       service.sendMessage(messageText)
    }
}*/
