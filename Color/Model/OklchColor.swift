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
        let roundedL = (l / 10).rounded() * 10
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
        let firstLetter = String(format: "%X", Int((l / 10).rounded()))
        let secondLetter = String(format: "%X", Int((c * 10).rounded()))
        let thirdLetter = String(convertToBase36(Int((h / 10).rounded())))

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
    
    init(id: String) {
        let first = id.first!
        let second = id.dropFirst().first!
        let third = id.dropFirst(2).first!
        
        let base36Letters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        let indexOfA = base36Letters.firstIndex(of: "A")!
        let firstEleven = base36Letters[...indexOfA]
        
        assert(id.count == 3, "The id must be 3 characters long.")
        assert(firstEleven.contains(first) && firstEleven.contains(second) && base36Letters.contains(third))
        
        let lIndex = base36Letters.firstIndex(of: first)!
        let cIndex = base36Letters.firstIndex(of: second)!
        let hIndex = base36Letters.firstIndex(of: third)!
        
        let lIntIndex: Int = base36Letters.distance(from: base36Letters.startIndex, to: lIndex)
        let cIntIndex: Int = base36Letters.distance(from: base36Letters.startIndex, to: cIndex)
        let hIntIndex: Int = base36Letters.distance(from: base36Letters.startIndex, to: hIndex)
        
        let l = CGFloat(lIntIndex) * 10
        let c = CGFloat(cIntIndex) / 10
        let h = CGFloat(hIntIndex) * 10
        
        self.init(l: l, c: c, h: h)
    }

    
    init(name: String? = nil, x: CGFloat, y: CGFloat, z: CGFloat) {
        self.name = name
        let lms: Matrix = ColorSpaceTransformation.xyzToLms.matrix * Matrix(column: (x, y, z))
        let nonLinearLms = Matrix(column: (cubeRoot(lms[0, 0]), cubeRoot(lms[1, 0]), cubeRoot(lms[2, 0])))
        let oklab: Matrix = ColorSpaceTransformation.nonLinearLmsToOklab.matrix * nonLinearLms
                                  
        self.l = oklab[0, 0] * 100
        let a = oklab[1, 0]
        let b = oklab[2, 0]
                                  
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
    
    private var oklab: Matrix {
        return Matrix(column: (l / 100, c * cos(hInRadians), c * sin(hInRadians)))
    }
    
    private var lms: Matrix {
        let nonLinearLms = ColorSpaceTransformation.oklabToNonLinearLms.matrix * oklab
        let linearLms = Matrix(column: (pow(nonLinearLms[0, 0], 3),
                                        pow(nonLinearLms[1, 0], 3),
                                        pow(nonLinearLms[2, 0], 3)))
        return linearLms
    }
    
    private var xyz: Matrix {
        return ColorSpaceTransformation.lmsToXYZ.matrix * lms
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

        let red = gammaCorrect(linearR)
        let green = gammaCorrect(linearG)
        let blue = gammaCorrect(linearB)

        return (red, green, blue)
    }
    
    var sRGB: Color {
        let (red, green, blue) = sRGBComponents
        print("\(name ?? representativeId) in sRGB is \((red, green, blue))")
        let colorSpace = CGColorSpace(name: CGColorSpace.extendedSRGB)!
        let color = CGColor(colorSpace: colorSpace, components: [red, green, blue, 1.0])!
        return Color(cgColor: color)
    }
    
    var a: CGFloat {
        return oklab[1,0]
    }
    
    var b: CGFloat {
        return oklab[2,0]
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
