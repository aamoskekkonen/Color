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
    let name: String?
    let l: CGFloat
    let c: CGFloat
    let h: CGFloat
    
    var representative: OklchColor {
        let roundedL = (l * 10).rounded() / 10
        let roundedC = (c * 10).rounded() / 10
        var roundedH = (h / 10).rounded() * 10
        if roundedH == 360 {
            roundedH = 0
        }
        
        return OklchColor(name: "Color", l: roundedL, c: roundedC, h: roundedH)
    }
    
    private func convertToBase36(_ number: Int) -> Character {
        let base36Letters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let index = number % base36Letters.count
        let character = base36Letters[base36Letters.index(base36Letters.startIndex, offsetBy: index)]
        return character
    }
    
    var representativeId: String {
        let firstLetter = String(format: "%X", Int(l * 10))
        let secondLetter = String(format: "%X", Int(c * 10))
        let thirdLetter = String(convertToBase36(Int(h / 10)))

        return firstLetter + secondLetter + thirdLetter
    }
    
    var representativeLightness: Int {
        let lightnessId = representativeId.prefix(1)
        assert("0123456789A".contains(lightnessId))
        if lightnessId == "A" {
            return 10
        } else {
            return Int(lightnessId)!
        }
    }

    init(name: String? = nil, l: CGFloat, c: CGFloat, h: CGFloat) {
        self.name = name
        self.l = l
        self.c = c
        self.h = h
    }
    
    init(name: String? = nil, x: CGFloat, y: CGFloat, z: CGFloat) {
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
    
    init(name: String? = nil, xChromaticity: CGFloat, yChromaticity: CGFloat, luminance: CGFloat) {
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
    
    var sRGBComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        func gammaCorrect(_ value: CGFloat) -> CGFloat {
            if value <= 0.0031308 {
                return 12.92 * value
            } else {
                return 1.055 * pow(value, 1/2.4) - 0.055
            }
        }
        
        let sRGBMatrix = ColorSpaceTransformation.XYZToSRGB.matrix * self.xyz
        let linearR = sRGBMatrix[0, 0]
        let linearG = sRGBMatrix[1, 0]
        let linearB = sRGBMatrix[2, 0]

        let r = gammaCorrect(linearR)
        let g = gammaCorrect(linearG)
        let b = gammaCorrect(linearB)
        print("\(name ?? representativeId) in sRGB is (\(r), \(g), \(b))")

        return (r, g, b)
    }
    
    var sRGB: Color? {
        let red = sRGBComponents.red
        let green = sRGBComponents.green
        let blue = sRGBComponents.blue
        if red >= 0.0 && red <= 1.0 && green >= 0.0 && green <= 1.0 && blue >= 0.0 && blue <= 1.0 {
            return Color(Color.RGBColorSpace.sRGB,
                         red: red,
                         green: green,
                         blue: blue)
        } else {
            return nil
        }
    }
    
    var displayP3Components: (red: CGFloat, green: CGFloat, blue: CGFloat) {
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
        print("\(name ?? representativeId) in Display P3 is (\(r), \(g), \(b))")

        return (r, g, b)
    }
    
    var displayP3: Color? {
        let red = displayP3Components.red
        let green = displayP3Components.green
        let blue = displayP3Components.blue
        if red >= 0.0 && red <= 1.0 && green >= 0.0 && green <= 1.0 && blue >= 0.0 && blue <= 1.0 {
            return Color(Color.RGBColorSpace.displayP3,
                         red: red,
                         green: green,
                         blue: blue)
        } else {
            return nil
        }
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
        hasher.combine(l)
        hasher.combine(c)
        hasher.combine(h)
    }
    
    
}
