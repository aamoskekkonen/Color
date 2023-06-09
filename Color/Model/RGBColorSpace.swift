//
//  RGBColorSpace.swift
//  Color
//
//  Created by Aamos Kekkonen on 12.6.2023.
//

import Foundation

class RGBColorSpace {
    let primaries: [OklchColor]
    let white: OklchColor
    
    init(primaries: [OklchColor], white: OklchColor) {
        self.primaries = primaries
        self.white = white
    }
    
    var transformationMatrixToXYZ: Matrix {
        let primariesC = primaries.map { primary in
            primary.chromaticity
        }
        let whiteC = white.chromaticity
        let M_prime = Matrix([
            [primariesC[0].x / primariesC[0].y, primariesC[1].x / primariesC[1].y, primariesC[2].x / primariesC[2].y],
            [1.0, 1.0, 1.0],
            [(1.0 - primariesC[0].x - primariesC[0].y) / primariesC[0].y,
             (1.0 - primariesC[1].x - primariesC[1].y) / primariesC[1].y,
             (1.0 - primariesC[2].x - primariesC[2].y) / primariesC[2].y]])
             
        let W = Matrix([
            [whiteC.x / whiteC.y],
            [1.0],
            [(1.0 - whiteC.x - whiteC.y) / whiteC.y]
        ])
        
        let S = M_prime.inverse() * W

        var result = M_prime
        for i in 0..<3 {
            for j in 0..<3 {
                result[i, j] *= S[j, 0]
            }
        }
        return result
    }
    
    var transformationMatrixFromXYZ: Matrix {
        return transformationMatrixToXYZ.inverse()
    }
}

extension RGBColorSpace {
    
    var red: OklchColor {
        return primaries[0]
    }
    
    var green: OklchColor {
        return primaries[1]
    }
    
    var blue: OklchColor {
        return primaries[2]
    }
    
    static var sRGB: RGBColorSpace {
        let red = OklchColor(name: "sRGB Red", x: 0.436, y: 0.222, z: 0.014)
        let green = OklchColor(name: "sRGB Green", x: 0.385, y: 0.717, z: 0.097)
        let blue = OklchColor(name: "sRGB Blue", x: 0.143, y: 0.061, z: 0.714)
        let white = OklchColor.d65
        return RGBColorSpace(primaries: [red, green, blue], white: white)
    }
    
    static var displayP3: RGBColorSpace {
//        let red = OklchColor(name: "P3 Red", x: 0.515, y: 0.241, z: -0.001)
//        let green = OklchColor(name: "P3 Green", x: 0.292, y: 0.692, z: 0.042)
//        let blue = OklchColor(name: "P3 Blue", x: 0.157, y: 0.067, z: 0.784)
        let red = OklchColor(name: "P3 Red", l: 64.9, c: 0.299, h: 29.03)
        let green = OklchColor(name: "P3 Green", l: 84.88, c: 0.36852781063661505, h: 145.64495037017772)
        let blue = OklchColor(name: "P3 Blue", l: 46.64, c: 0.323, h: 264.05)
//        let red = OklchColor(x: 0.68, y: 0.32, z: 0)
//        let green = OklchColor(x: 0.265, y: 0.69, z: 0.045)
//        let blue = OklchColor(x: 0.15, y: 0.06, z: 0.79)
        let white = OklchColor.d65
        return RGBColorSpace(primaries: [red, green, blue], white: white)
    }
}

///         let r = OklchColor(xChromaticity: 0.64, yChromaticity: 0.33, luminance: 0.2126)
///         let g = OklchColor(xChromaticity: 0.3, yChromaticity: 0.6, luminance: 0.7152)
///         let b = OklchColor(xChromaticity: 0.15, yChromaticity: 0.06, luminance: 0.0722)
