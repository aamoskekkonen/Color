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
    
    init(l: CGFloat, c: CGFloat, h: CGFloat) {
        self.l = l
        self.c = c
        self.h = h
    }
    
    var a: CGFloat {
        return c * cos(h)
    }
    
    var b: CGFloat {
        return c * sin(h)
    }
    
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        let lms: Matrix = ColorSpaceTransformation.XYZToLms.matrix * Matrix(column: (x, y, z))
        let nonLinearLms = Matrix(column: (pow(lms[0, 0], 1.0/3), pow(lms[1, 0], 1.0/3), pow(lms[2, 0], 1.0/3)))
        let lab: Matrix = ColorSpaceTransformation.nonLinearLmsToLab.matrix * nonLinearLms
                                  
        self.l = lab[0, 0]
        let a = lab[1, 0]
        let b = lab[2, 0]
                                  
        self.c = sqrt(pow(a, 2) + pow(b, 2))
        self.h = atan2(b, a)
    }
}
