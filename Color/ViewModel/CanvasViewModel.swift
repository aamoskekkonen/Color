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
    @Published var selectedColors: [OklchColor]
    
    let defaultPointDiameter: CGFloat
    
    var referenceColors: [OklchColor] {
        var colors: [OklchColor] = []
        for l in stride(from: 0.0, through: 1.0, by: 0.1) {
            for c in stride(from: 0.0, through: OklchColor.maxA, by: 0.1) {
                for h in stride(from: 0, through: 350, by: 10) {
                
                    let color = OklchColor(l: l, c: c, h: CGFloat(h))
                    colors.append(color)
                }
            }
        }
        return colors
    }
    
    
    var origo: CGPoint {
        return CGPoint(x: defaultCanvasWidth / 2, y: defaultCanvasWidth / 2)
    }

    init(colors: [OklchColor], initialCanvasWidth: CGFloat, initialPointDiameter: CGFloat) {
        self.defaultCanvasWidth = initialCanvasWidth
        self.currentCanvasWidth = initialCanvasWidth
        self.data = colors.map { color in
            print("The color is \(color.name): (l = \(color.l), a = \(color.a), b = \(color.b), c = \(color.c), h = \(color.h)")
            let radius = initialCanvasWidth / 2
            let aRatio = color.a / OklchColor.maxA
            let bRatio = color.b / OklchColor.maxB
            print("aRatio = \(aRatio), bRatio = \(bRatio)")
            let x = radius + aRatio * radius
            let y = radius - bRatio * radius
            print("(x,y) = \((x, y))")
            print("")
            return ColorRepresentationData(
                color: color,
                point: CGPoint(x: x, y: y),
                diameter: initialPointDiameter,
                isSelected: false)
        }
        self.defaultPointDiameter = initialPointDiameter
        self.selectedColors = []
    }
    
    func toggleSelect(color: OklchColor) {
        if let index = selectedColors.firstIndex(of: color) {
            selectedColors.remove(at: index)
        } else {
            selectedColors.append(color)
        }
    }
    
    func hasSelected(color: OklchColor) -> Bool {
        return selectedColors.contains(color)
    }
}

struct ColorRepresentationData: Identifiable {
    let id = UUID()
    let color: OklchColor
    let point: CGPoint
    let diameter: CGFloat
    var isSelected: Bool
}
