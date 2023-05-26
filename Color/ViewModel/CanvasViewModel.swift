//
//  CanvasViewModel.swift
//  Color
//
//  Created by Aamos Kekkonen on 26.5.2023.
//

import Foundation
import SwiftUI

class CanvasViewModel: ObservableObject {
    let defaultCanvasWidth: CGFloat
    @Published var currentScale: CGFloat
    @Published var data: [ColorRepresentationData]
    
    let defaultPointDiameter: CGFloat = 15.0
    
    init(colors: [OklchColor], initialCanvasWidth: CGFloat, initialPointDiameter: CGFloat) {
        self.defaultCanvasWidth = initialCanvasWidth
        self.currentScale = initialCanvasWidth
        self.data = colors.map { color in
            let x = (initialCanvasWidth / 2) * (1 + (color.a / OklchColor.maxA))
            let y = -(initialCanvasWidth / 2) * (1 + (color.b / OklchColor.maxB))
            return ColorRepresentationData(
                color: color,
                point: CGPoint(x: x, y: y),
                diameter: initialPointDiameter)
        }
    }
}

struct ColorRepresentationData: Identifiable {
    let id = UUID()
    let color: OklchColor
    let point: CGPoint
    let diameter: CGFloat
}
