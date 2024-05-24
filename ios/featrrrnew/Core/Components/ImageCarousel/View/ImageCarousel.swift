//
//  ImageCarousel.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/3/24.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct ImageCarousel: View {
    
    let padding: EdgeInsets
    
    internal var width: CGFloat?
    internal var height: CGFloat?
    internal var cornerRadius: CGFloat = .cornerM
    
    @Binding var carouselItems: [ImageCarouselItem]
    @State private var bottomPageControllerPadding: CGFloat = 8
    @State private var selectedImageIndex = 0
    @State internal var pageControllerHidden = false
    private var placeholder: AnyView?
    
    // Calculated
    private var imageSize: CGSize {
        get {
            return CGSize(width: width == nil ? UIScreen.main.bounds.width - (self.padding.trailing + self.padding.leading) : width!, height: height == nil ? UIScreen.main.bounds.width - (self.padding.trailing + self.padding.leading) : height!)
        }
    }
    
    init(carouselItems: Binding<[ImageCarouselItem]>, padding: EdgeInsets = .init()) {
        self.padding = padding
        self._carouselItems = carouselItems
        
    }
    init(images: [UIImage], padding: EdgeInsets = .init()) {
        self.padding = padding
        var carouselItems: [ImageCarouselItem] = []
        for image in images {
            carouselItems.append(ImageCarouselItem(image: image))
        }
        self._carouselItems = Binding.constant(carouselItems)
    }
    
    init(urls: [String], padding: EdgeInsets = .init()) {
        self.padding = padding
        var carouselItems: [ImageCarouselItem] = []
        for url in urls {
            carouselItems.append(ImageCarouselItem(url: url))
        }
        self._carouselItems = Binding.constant(carouselItems)
    }
    
    func loadImage(url: URL?, i: Int) -> some View {
         KFImage(url)
            .resizable()
            .scaledToFill()
            .frame(width: imageSize.width, height: imageSize.height)
            .clipped()
            .clipShape(ImageCarouselClipShape(isFirst: i == 0, isLast: i == carouselItems.count - 1, cornerRadius: cornerRadius))
    }
    
    func staticImage(image: UIImage, i: Int) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: imageSize.width, height: imageSize.height)
            .clipped()
            .clipShape(ImageCarouselClipShape(isFirst: i == 0, isLast: i == carouselItems.count - 1, cornerRadius: cornerRadius))
    }
    var body: some View {
       
            ZStack(alignment: .bottom) {
                
                TabView(selection: $selectedImageIndex) {
                    
                    if carouselItems.count > 0 {
                        ForEach(0..<carouselItems.count, id: \.self) { i in
                            ZStack {
                                if let url = carouselItems[i].url {
                                    loadImage(url: URL(string: url), i: i)
                                } else if let image = carouselItems[i].image {
                                    staticImage(image: image, i: i)
                                }
                            }
                        }
                    } else {
                        placeholder
                    }
                    
                }
                .frame(width: imageSize.width, height: imageSize.height)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay {
                        if self.carouselItems.count > 0 && pageControllerHidden == false {
                            DynamicPageControllerView(itemCount: self.carouselItems.count, currentItem: $selectedImageIndex, bottomPadding: bottomPageControllerPadding)
                        }
                    }
            }
        
    }
    
    public func pageControllerOffset(x offset: CGFloat) -> some View {
        var view = self
        view._bottomPageControllerPadding = State(initialValue: offset)
        return view.id(UUID())
    }


}

internal struct ImageCarouselClipShape: Shape {
    let isFirst: Bool
    let isLast: Bool
    let cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        UnevenRoundedRectangle(topLeadingRadius: isFirst ? cornerRadius : 0, bottomLeadingRadius: isFirst ? cornerRadius : 0, bottomTrailingRadius: isLast ? cornerRadius : 0, topTrailingRadius: isLast ? cornerRadius : 0, style: .circular).path(in: rect)
    }
}
extension ImageCarousel {
    public func refundSized() -> Self {
        
        var view = self
        view.width = 120
        view.height = 160
        view.cornerRadius = 16
        
        return view
    }
    
    public func minified() -> Self {
        
        var view = self
        view.width = 120
        view.height = 210
        view.cornerRadius = 10
        
        return view
    }
    public func threeFour() -> Self {
        
        var view = self
        let size = CGSize(width: (UIScreen.main.bounds.width - (self.padding.trailing + self.padding.leading)), height: (UIScreen.main.bounds.width - (self.padding.trailing + self.padding.leading))*(4/3))
        view.width = size.width
        view.height = size.height
        view.cornerRadius = 0
        
        return view
    }
    public func minifiedThreeFour() -> Self {
        
        var view = self
        let screenWidth = UIScreen.main.bounds.width
        let imageWidth = screenWidth/2  - (self.padding.trailing + self.padding.leading)
        let size = CGSize(width: imageWidth, height: imageWidth*(4/3))
        view.width = size.width
        view.height = size.height
        view.cornerRadius = 16
        
        return view
    }
    
    public func preview() -> Self {
        
        var view = self
        view.width = 120
        view.height = 120
        view.cornerRadius = 8
        
        return view
    }
    
    public func hidePageController() -> Self {
        var view = self
        view.pageControllerHidden = true
        return view
    }
    
    public func addPlaceholder(noContent placeholder: some View) -> Self {
        var view = self
        view.placeholder = AnyView(placeholder)
        return view
    }
}

#Preview {
    ImageCarousel(carouselItems: .constant([ImageCarouselItem(url: "https://picsum.photos/200/200")]))
}
