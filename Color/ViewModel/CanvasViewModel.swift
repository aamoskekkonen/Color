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
    @Published var layer: Int
    @Published var lastClickedColor: OklchColor?
    
    let defaultPointDiameter: CGFloat

    init(colors: [OklchColor], initialCanvasWidth: CGFloat, initialPointDiameter: CGFloat) {
        self.defaultCanvasWidth = initialCanvasWidth
        self.currentCanvasWidth = initialCanvasWidth
        self.data = colors.map { color in
            let radius = initialCanvasWidth / 2
            let aRatio = color.a / OklchColor.maxA
            let bRatio = color.b / OklchColor.maxB
            let x = radius + aRatio * radius
            let y = radius - bRatio * radius
            return ColorRepresentationData(
                color: color,
                point: CGPoint(x: x, y: y),
                diameter: initialPointDiameter,
                isSelected: false)
        }
        self.defaultPointDiameter = initialPointDiameter
        self.selectedColors = []
        self.layer = 5
        self.lastClickedColor = nil
    }
    
    func toggleSelect(color: OklchColor) {
        self.lastClickedColor = color
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

extension CanvasViewModel {
    
    var origo: CGPoint {
        return CGPoint(x: defaultCanvasWidth / 2, y: defaultCanvasWidth / 2)
    }
    
    static var referenceColors: [OklchColor] {
        var colors: [OklchColor] = []
        for l in stride(from: 0.0, through: 100.0, by: 10.0) {
            var neutralAdded = false
            for c in stride(from: 0.0, through: OklchColor.maxA, by: 0.1) {
                for h in stride(from: 0.0, through: 350.0, by: 10.0) {
                    let color = OklchColor(l: l, c: c, h: CGFloat(h))
                    if c == 0.0 && h == 0 {
                        colors.append(color)
                        neutralAdded = true
                    }
                    if !(c == 0.0 && neutralAdded) {
                        colors.append(color)
                    }
                }
            }
        }
        return colors
    }
}
