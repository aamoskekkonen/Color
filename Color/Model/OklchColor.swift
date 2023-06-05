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
        assert(firstEleven.contains(first) && base36Letters.contains(second) && base36Letters.contains(third))
        
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
        let lms: Matrix = ColorSpaceTransformation.xyzToLms.matrix * Matrix(column: (x, y, z))
        let nonLinearLms = Matrix(column: (cubeRoot(lms[0, 0]), cubeRoot(lms[1, 0]), cubeRoot(lms[2, 0])))
        let oklab: Matrix = ColorSpaceTransformation.nonLinearLmsToOklab.matrix * nonLinearLms
                            
        let a = oklab[1, 0]
        let b = oklab[2, 0]
        let radianH = atan2(b, a)
        
        self.name = name
        self.l = oklab[0, 0] * 100
        self.c = sqrt(pow(a, 2) + pow(b, 2))
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
        let nonLinearLms = ColorSpaceTransformation.oklabToNonLinearLms.matrix * self.oklab
        return Matrix(column: (pow(nonLinearLms[0, 0], 3),
                               pow(nonLinearLms[1, 0], 3),
                               pow(nonLinearLms[2, 0], 3)))
    }
    
    private var xyz: Matrix {
        return ColorSpaceTransformation.lmsToXYZ.matrix * self.lms
    }
    
    var sRGBComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let sRGBMatrix = ColorSpaceTransformation.XYZToSRGB.matrix * self.xyz
        return gammaCorrect((sRGBMatrix[0, 0], sRGBMatrix[1, 0], sRGBMatrix[2, 0]))
    }
    
    var displayP3Components: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let displayP3Matrix = ColorSpaceTransformation.XYZToDisplayP3.matrix * self.xyz
        return gammaCorrect((displayP3Matrix[0, 0], displayP3Matrix[1, 0], displayP3Matrix[2, 0]))
    }
    
    var color: Color {
        let (r, g, b) = sRGBComponents
        let colorSpace = CGColorSpace(name: CGColorSpace.extendedSRGB)!
        let cgColor = CGColor(colorSpace: colorSpace, components: [r, g, b, 1])!
        return Color(cgColor: cgColor)
    }
    
}

extension OklchColor {
    
    static let maxA: CGFloat = 1.0
    static let maxB: CGFloat = 1.0
    
    var a: CGFloat {
        return oklab[1,0]
    }
    
    var b: CGFloat {
        return oklab[2,0]
    }
    
    var representative: OklchColor {
        let roundedL = (l / 10).rounded() * 10
        let roundedC = (c * 10).rounded() / 10
        var roundedH = (h / 10).rounded() * 10
        if roundedH == 360 {
            roundedH = 0
        }
        
        return OklchColor(name: "Color", l: roundedL, c: roundedC, h: roundedH)
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
    
    private func isOutOfRange(in components: (CGFloat, CGFloat, CGFloat)) -> Bool {
        let (r, g, b) = components
        let accuracy = 1e-4
        let lowerLimit = 0.0 - accuracy
        let upperLimit = 1.0 + accuracy
        let redOk = r < lowerLimit || r > upperLimit
        let greenOk = g < lowerLimit || g > upperLimit
        let blueOk = b < lowerLimit || b > lowerLimit
        return redOk && greenOk && blueOk
    }
    
    var isOutOfSRGB: Bool {
        return isOutOfRange(in: sRGBComponents)
    }
    
    var isOutOfDisplayP3: Bool {
        return isOutOfRange(in: displayP3Components)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(l)
        hasher.combine(c)
        hasher.combine(h)
    }
    
}
