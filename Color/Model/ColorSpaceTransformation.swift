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
    
    static let XYZ_to_LMS = ColorSpaceTransformation([
        [0.8189330101, 0.3618667424, -0.1288597137],
        [0.0329845436, 0.9293118715, 0.0361456387],
        [0.0482003018, 0.2643662691, 0.6338517070]
    ])
    
    static let LMS_to_XYZ = ColorSpaceTransformation(XYZ_to_LMS.matrix.inverse().data)
    
    static let nonLinearLMS_to_Oklab = ColorSpaceTransformation([
        [0.2104542553, 0.7936177850, -0.0040720468],
        [1.9779984951, -2.4285922050, 0.4505937099],
        [0.0259040371, 0.7827717662, -0.8086757660]
    ])
    
    static let Oklab_to_nonLinearLMS = ColorSpaceTransformation(nonLinearLMS_to_Oklab.matrix.inverse().data)
    
    static let XYZ_to_sRGB = ColorSpaceTransformation([
        [3.2406, -1.5372, -0.4986],
        [-0.9689, 1.8758, 0.0415],
        [0.0557, -0.2040, 1.0570]
    ])
    
    static let sRGB_to_XYZ = ColorSpaceTransformation(XYZ_to_sRGB.matrix.inverse().data)
    
    static let XYZ_to_DisplayP3 = ColorSpaceTransformation([
        [2.493496911941425, -0.9313836179191239, -0.40271078445071684],
        [-0.8294889695615747, 1.7626640603183463, 0.023624685841943577],
        [0.03584583024378447, -0.07617238926804182, 0.9568845240076872]
    ])
    
    static let DisplayP3_to_XYZ = ColorSpaceTransformation(XYZ_to_DisplayP3.matrix.inverse().data)
}
