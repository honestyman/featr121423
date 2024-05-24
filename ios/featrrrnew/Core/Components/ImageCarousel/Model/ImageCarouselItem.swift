//
//  ImageCarouselItem.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/22/24.
//

import Foundation
import UIKit
import PhotosUI
import SwiftUI

class ImageCarouselItem: Identifiable {
    var id: UUID
    var url: String? = nil
    var image: UIImage? = nil
    
    init(url: String) {
        self.url = url
        self.id = UUID()
    }
    init(image: UIImage) {
        self.image = image
        self.id = UUID()
    }
}

extension ImageCarouselItem  {
    
    @MainActor
    static func arrayWithItems(_ items: [PhotosPickerItem]) async -> [ImageCarouselItem] {
        var imageI: [ImageCarouselItem] = []
        for item in items {
            guard let data = try? await item.loadTransferable(type: Data.self) else { continue }
            guard let image = UIImage(data: data) else { continue }
            let imageCarouselItem = ImageCarouselItem(image: image)
            imageI.append(imageCarouselItem)
        }
        return imageI
    }
}
