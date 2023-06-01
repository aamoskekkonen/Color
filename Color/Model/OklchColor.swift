//
//  OklchColor.swift
//  Color
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import Foundation
import CoreGraphics
import SwiftUI

struct OklchColor: Decodable, Hashable {
    let name: String
    let l: CGFloat
    let c: CGFloat
    let h: CGFloat
    
    init(name: String, l: CGFloat, c: CGFloat, h: CGFloat) {
        self.name = name
        self.l = l
        self.c = c
        self.h = h
    }
    
    init(name: String, x: CGFloat, y: CGFloat, z: CGFloat) {
        self.name = name
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
    
    init(name: String, xChromaticity: CGFloat, yChromaticity: CGFloat, luminance: CGFloat) {
        let x = (xChromaticity * luminance) / yChromaticity
        let y = luminance
        let z = (1.0 - xChromaticity - yChromaticity) * (luminance / yChromaticity)
        self.init(name: name, x: x, y: y, z: z)
    }
    
    private var hInRadians: CGFloat {
        return (h / 360) * 2 * CGFloat.pi
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
    
    var displayP3: Color {
        func gammaCorrect(_ value: CGFloat) -> CGFloat {
            if value <= 0.0031308 {
                return 12.92 * value
            } else {
                return 1.055 * pow(value, 1/2.4) - 0.055
            }
        }
        
        let displayP3Matrix = ColorSpaceTransformation.XYZToDisplayP3.matrix * self.xyz
        let linearR = displayP3Matrix[0, 0]
        let linearG = displayP3Matrix[1, 0]
        let linearB = displayP3Matrix[2, 0]

        let r = gammaCorrect(linearR)
        let g = gammaCorrect(linearG)
        let b = gammaCorrect(linearB)

        return Color(.displayP3, red: r, green: g, blue: b, opacity: 1.0)
    }
    
    var a: CGFloat {
        return lab[1,0]
    }
    
    var b: CGFloat {
        return lab[2,0]
    }
    
    static let maxA: CGFloat = 1.0
    static let maxB: CGFloat = 1.0
    
}

extension OklchColor {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(l)
        hasher.combine(c)
        hasher.combine(h)
    }
    
    
}
