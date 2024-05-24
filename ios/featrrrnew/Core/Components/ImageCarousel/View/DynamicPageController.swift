//
//  DynamicPageControllerView.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/13/24.
//

import SwiftUI


struct DynamicPageControllerView: View {
    
    // Public (State)
    @Binding var currentItem: Int
    @State var offset: CGFloat = 0
    
    // Private (State)
    @State private var hStackWidth: CGFloat = 0.0
    @State private var hStackHeight: CGFloat = 0.0
    
    // Public
    public let itemCount: Int
    public var bottomPadding: CGFloat = 8
    
    // Private (Calculated)
    private var itemCountFloat: CGFloat {
        get {
            return CGFloat(itemCount)
        }
    }
    
    private var indicatorDisplayCount: CGFloat {
        get {
            return min(CGFloat(maxIndicatorDisplayCount), itemCountFloat)
        }
    }
    
    private var horizontalPadding: CGFloat = 16
    private let maxIndicatorDisplayCount = 4
    private let indicatorSmallRadius: Int = 4
    private let indicatorRegularRadius: Int = 7
    
   
    init(itemCount: Int, currentItem: Binding<Int>, bottomPadding: CGFloat? = nil) {
        if itemCount <= 0 {
            fatalError("There must be at least one item specified")
        }
        
        self.itemCount = itemCount
        self._currentItem = currentItem
        if let bottomPadding = bottomPadding {
            self.bottomPadding = bottomPadding
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment:.bottomLeading) {
                Color.clear // Fill entire screen
                ZStack {
                    
                }.frame(width: (hStackWidth/itemCountFloat)*indicatorDisplayCount, height: hStackHeight)
                    .padding(.horizontal, horizontalPadding)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16.0))
                
                HStack(spacing: CGFloat.sm) {
                    
                    ForEach(0..<itemCount, id: \.self) { index in
                        // Step 13: Create Navigation Dots
                        Circle()
                            .fill(Color.background.opacity(currentItem == index ? 1 : 0.33))
                            .frame(width: 7, height: CGFloat(circleHeight(index)))
                            .onTapGesture {
                                currentItem = index
                            }
                            .animation(.easeInOut(duration: 0.3), value: currentItem)
                            .animation(.easeInOut(duration: 0.3), value: offset)
                    }
                    
                }
                .offset(x: offset + horizontalPadding)
                .padding(.vertical, .sm)
                .padding(.horizontal, 0)
                .overlay {
                    GeometryReader { proxy in
                        Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
                    }
                }
                .onPreferenceChange(SizePreferenceKey.self, perform: { width in
                    self.hStackWidth = width.width
                    self.hStackHeight = width.height
                })
                .onChange(of: currentItem, perform: { newValue in
                    calculateOffset()
                })
            }.offset(x: proxy.size.width/2 - (hStackWidth/itemCountFloat)*(indicatorDisplayCount/2) - horizontalPadding)
        }
        .padding(bottomPadding)
       
    }

    private func calculateOffset() {
        let cushionDotsRight = 1
        let scrollingI = (maxIndicatorDisplayCount - cushionDotsRight) - 1
        if currentItem >= scrollingI && currentItem < itemCount - cushionDotsRight {
            offset = -(hStackWidth / itemCountFloat)*CGFloat(currentItem - scrollingI)
        }
    }
    
    private func circleHeight(_ itemIndex: Int) -> Int {
        let cushionDotRight = 1 //TODO: There's a logic error below
        let offset = max(0, currentItem - (maxIndicatorDisplayCount - 1 - cushionDotRight))
        
        
        if itemIndex - offset < maxIndicatorDisplayCount - 1 {
            if itemIndex - offset > 0 {
                return indicatorRegularRadius
            } else if itemIndex - offset == 0 {
                if offset == 0 ||  currentItem >= itemCount - cushionDotRight{
                    //Representing the edges of the arrays
                    return indicatorRegularRadius
                } else  {
                    // Representing the right (not edge)
                    return indicatorSmallRadius
                }

            } else {
                
                if currentItem >= itemCount - 1 && itemIndex >= itemCount - maxIndicatorDisplayCount{
                    // Representing the left edge [end iteration]
                    return indicatorSmallRadius
                } else {
                    return .zero
                }
            }
        } else if itemIndex - offset == maxIndicatorDisplayCount - 1 {
            // Representing the right edge
            return indicatorSmallRadius
        } else {
            return .zero
        }
    }
}
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

#Preview {
    DynamicPageControllerView(itemCount: 7, currentItem: .constant(5))
        .background(Color.background)
        
}
