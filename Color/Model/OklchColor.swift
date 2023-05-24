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
    
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        let XYZToLms = Matrix([
            [0.8189330101, 0.3618667424, -0.1288597137],
            [0.0329845436, 0.9293118715, 0.0361456387],
            [0.0482003018, 0.2643662691, 0.6338517070]
        ])
        let nonLinearLmsToLab = Matrix([
            [0.2104542553, 0.7936177850, -0.0040720468],
            [1.9779984951, -2.4285922050, 0.4505937099],
            [0.0259040371, 0.7827717662, -0.8086757660]
        ])
        let lms: Matrix = XYZToLms * Matrix(column: (x, y, z))
        let nonLinearLms = Matrix(column: (pow(lms[0, 0], 1.0/3),
                                           pow(lms[1, 0], 1.0/3),
                                           pow(lms[2, 0], 1.0/3)))
        let result: Matrix = nonLinearLmsToLab * nonLinearLms
                                  
        self.l = result[0, 0]
                                  
        let a = result[1, 0]
        let b = result[2, 0]
                                  
        self.c = sqrt(pow(a, 2) + pow(b, 2))
        self.h = atan2(b, a)
    }
}
