//
//  OklchColor.swift
//  Color
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import Foundation
import CoreGraphics

struct OklchColor {
    let l: CGFloat
    let c: CGFloat
    let h: CGFloat
    
    init(l: CGFloat, c: CGFloat, h: CGFloat) {
        self.l = l
        self.c = c
        self.h = h
        let radianH = ((h - 180) / 180) * CGFloat.pi
    }
    
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        let lms: Matrix = ColorSpaceTransformation.XYZToLms.matrix * Matrix(column: (x, y, z))
        let nonLinearLms = Matrix(column: (cubeRoot(lms[0, 0]), cubeRoot(lms[1, 0]), cubeRoot(lms[2, 0])))
        let lab: Matrix = ColorSpaceTransformation.nonLinearLmsToLab.matrix * nonLinearLms
                                  
        self.l = lab[0, 0]
        let a = lab[1, 0]
        let b = lab[2, 0]
                                  
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
    
    private var hInRadians: CGFloat {
        return ((h - 180) / 180) * CGFloat.pi
    }
    
    private var lab: Matrix {
        return Matrix(column: (l, c * cos(hInRadians), c * sin(hInRadians)))
    }
    
    private var lms: Matrix {
        let nonLinearLms = ColorSpaceTransformation.labToNonLinearLms.matrix * lab
        let linearLms = Matrix(column: (pow(nonLinearLms[0, 0], 3),
                                        pow(nonLinearLms[1, 0], 3),
                                        pow(nonLinearLms[2, 0], 3)))
        return linearLms
    }
    
    private var xyz: Matrix {
        return ColorSpaceTransformation.LmsToXYZ.matrix * lms
    }
    
    var displayP3: CGColor {
        let xyzColorSpace = CGColorSpace(name: CGColorSpace.genericXYZ)!
        let xyzColor = CGColor(colorSpace: xyzColorSpace, components: [xyz[0, 0], xyz[1, 0], xyz[2, 0]])!
        return xyzColor.converted(to: CGColorSpace(name: CGColorSpace.displayP3)!, intent: .absoluteColorimetric, options: nil)!
    }
}
