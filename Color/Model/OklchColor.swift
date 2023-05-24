//
//  OklchColor.swift
//  Color
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import Foundation

struct OklchColor {
    let l: CGFloat
    let c: CGFloat
    let h: CGFloat
    let a: CGFloat
    let b: CGFloat
    
    init(l: CGFloat, c: CGFloat, h: CGFloat) {
        self.l = l
        self.c = c
        self.h = h
        let radianH = ((h - 180) / 180) * CGFloat.pi
        self.a = c * cos(radianH)
        self.b = c * sin(radianH)
    }
    
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        let lms: Matrix = ColorSpaceTransformation.XYZToLms.matrix * Matrix(column: (x, y, z))
        let nonLinearLms = Matrix(column: (cubeRoot(lms[0, 0]), cubeRoot(lms[1, 0]), cubeRoot(lms[2, 0])))
        let lab: Matrix = ColorSpaceTransformation.nonLinearLmsToLab.matrix * nonLinearLms
                                  
        self.l = lab[0, 0]
        self.a = lab[1, 0]
        self.b = lab[2, 0]
                                  
        self.c = sqrt(pow(a, 2) + pow(b, 2))
        let radianH = atan2(b, a)
        self.h = radianH >= 0 ? (radianH / CGFloat.pi) * 180 : (radianH / CGFloat.pi) * 180 + 360
    }
    
    init(xChromaticity: CGFloat, yChromaticity: CGFloat, luminance: CGFloat) {
        let x = (xChromaticity * luminance) / yChromaticity
        let y = luminance
        let z = (1.0 - xChromaticity - yChromaticity) * (luminance / yChromaticity)
        self.init(x: x, y: y, z: z)
    }
}
