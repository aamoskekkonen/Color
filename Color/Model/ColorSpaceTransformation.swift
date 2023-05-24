//
//  TransformationMatrix.swift
//  Color
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import Foundation

class ColorSpaceTransformation {
    let matrix: Matrix
    
    init(_ data: [[CGFloat]]) {
        self.matrix = Matrix(data)
    }
    
    static let XYZToLms = ColorSpaceTransformation([
        [0.8189330101, 0.3618667424, -0.1288597137],
        [0.0329845436, 0.9293118715, 0.0361456387],
        [0.0482003018, 0.2643662691, 0.6338517070]
    ])
    static let nonLinearLmsToLab = ColorSpaceTransformation([
        [0.2104542553, 0.7936177850, -0.0040720468],
        [1.9779984951, -2.4285922050, 0.4505937099],
        [0.0259040371, 0.7827717662, -0.8086757660]
    ])
}

