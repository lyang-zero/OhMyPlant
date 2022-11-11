//
//  ObseverableScrollView.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-09.
//

import SwiftUI

struct ObservableScrollView<Content: View>: View {
    
    private var content: Content
    
    @Binding var offSet: CGPoint
    private let showIndicator: Bool
    private let axis: Axis.Set
    
    init(offset: Binding<CGPoint>, showIndicator: Bool = false, axis: Axis.Set = .vertical, @ViewBuilder content: () -> Content) {
        self.content = content()
        self._offSet = offset
        self.axis = axis
        self.showIndicator = showIndicator
    }
    
    @State private var startOffset: CGPoint = .zero
    var body: some View {
        ScrollView(axis, showsIndicators: showIndicator, content: {
            content
                .overlay(
                    GeometryReader { proxy -> Color in
                        let rect = proxy.frame(in: .global)
                        DispatchQueue.main.async {
                            if self.startOffset == .zero {
                                self.startOffset = CGPoint(x: rect.minX, y: rect.minY)
                            }
                            self.offSet = CGPoint(x: startOffset.x - rect.minX, y: startOffset.y - rect.minY)
                        }
                        return Color.clear
                    }
                )
//            
//            GeometryReader { proxy -> Content in
//                let rect = proxy.frame(in: .global)
//                DispatchQueue.main.async {
//                    if self.startOffset == .zero {
//                        self.startOffset = CGPoint(x: rect.minX, y: rect.minY)
//                    }
//                    self.offSet = CGPoint(x: startOffset.x - rect.minX, y: startOffset.y - rect.minY)
//                }
//                return content
//            }
        })
    }
}
