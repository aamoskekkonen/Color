//
//  CanvasViewModel.swift
//  Color
//
//  Created by Aamos Kekkonen on 26.5.2023.
//

import Foundation
import SwiftUI
import CoreGraphics

class CanvasViewModel: ObservableObject {
    let defaultCanvasWidth: CGFloat
    @Published var currentCanvasWidth: CGFloat
    @Published var data: [ColorRepresentationData]
    
    let defaultPointDiameter: CGFloat
    
    var origo: CGPoint {
        return CGPoint(x: defaultCanvasWidth / 2, y: defaultCanvasWidth / 2)
    }

    init(colors: [OklchColor], initialCanvasWidth: CGFloat, initialPointDiameter: CGFloat) {
        self.defaultCanvasWidth = initialCanvasWidth
        self.currentCanvasWidth = initialCanvasWidth
        self.data = colors.map { color in
            let radius = initialCanvasWidth / 2
            let x = radius + (color.a / OklchColor.maxA) * radius
            let y = radius - (color.b / OklchColor.maxB) * radius
            return ColorRepresentationData(
                color: color,
                point: CGPoint(x: x, y: y),
                diameter: initialPointDiameter,
                isSelected: false)
        }
        self.defaultPointDiameter = initialPointDiameter
        print(data.map({ data in
            data.point
        }))
        print(defaultCanvasWidth)
        print(data.map({ data in
            (data.color.a, data.color.b)
        }))
    }
    
}

class ColorRepresentationData: Identifiable {
    let id = UUID()
    let color: OklchColor
    let point: CGPoint
    let diameter: CGFloat
    var isSelected: Bool
    
    init(color: OklchColor, point: CGPoint, diameter: CGFloat, isSelected: Bool) {
        self.color = color
        self.point = point
        self.diameter = diameter
        self.isSelected = isSelected
    }
    
    func select() {
        isSelected = true
    }
}
