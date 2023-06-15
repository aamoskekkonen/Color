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

    /// This works correctly
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
        let lms: Matrix = ColorSpaceTransformation.XYZ_to_LMS.matrix * Matrix(column: (x, y, z))
        let nonLinearLms = Matrix(column: (cubeRoot(lms[0, 0]), cubeRoot(lms[1, 0]), cubeRoot(lms[2, 0])))
        let oklab: Matrix = ColorSpaceTransformation.nonLinearLMS_to_Oklab.matrix * nonLinearLms
                            
        let a = oklab[1, 0]
        let b = oklab[2, 0]
        let radianH = atan2(b, a)
        
        self.name = name
        self.l = oklab[0, 0] * 100
        self.c = sqrt(pow(a, 2) + pow(b, 2))
        self.h = radianH >= 0 ? (radianH / CGFloat.pi) * 180 : (radianH / CGFloat.pi) * 180 + 360
    }
    
    /// This works correctly
    init(name: String? = nil, xChromaticity: CGFloat, yChromaticity: CGFloat, luminance: CGFloat) {
        let x = (xChromaticity * luminance) / yChromaticity
        let y = luminance
        let z = (1.0 - xChromaticity - yChromaticity) * (luminance / yChromaticity)
        self.init(name: name, x: x, y: y, z: z)
    }
    
    init(name: String? = nil, sRGBRed: Int, sRGBGreen: Int, sRGBBlue: Int) {
        let r = gammaDecode_sRGB(CGFloat(sRGBRed) / 255)
        let g = gammaDecode_sRGB(CGFloat(sRGBGreen) / 255)
        let b = gammaDecode_sRGB(CGFloat(sRGBBlue) / 255)
        let xyz = RGBColorSpace.sRGB.transformationMatrixToXYZ * Matrix(column: (r, g, b))
        self.init(name: name, x: xyz[0,0], y: xyz[1,0], z: xyz[2,0])
    }
    
    /// This works correctly
    private var hInRadians: CGFloat {
        return (h / 360) * 2 * CGFloat.pi
    }
    
    /// This works correctly
    private var oklab: Matrix {
        return Matrix(column: (l / 100, c * cos(hInRadians), c * sin(hInRadians)))
    }
    
    /// This works correctly
    private var lms: Matrix {
        let nonLinearLms = ColorSpaceTransformation.Oklab_to_nonLinearLMS.matrix * self.oklab
        return Matrix(column: (pow(nonLinearLms[0, 0], 3),
                               pow(nonLinearLms[1, 0], 3),
                               pow(nonLinearLms[2, 0], 3)))
    }
    
    /// This works correctly
    var xyz: Matrix {
        return ColorSpaceTransformation.LMS_to_XYZ.matrix * self.lms
    }
    
    // this is wrooong!
    var sRGBComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let sRGBMatrix = RGBColorSpace.sRGB.transformationMatrixFromXYZ * self.xyz
        return gammaEncode_sRGB((sRGBMatrix[0, 0], sRGBMatrix[1, 0], sRGBMatrix[2, 0]))
    }
    
    var displayP3Components: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let displayP3Matrix = RGBColorSpace.displayP3.transformationMatrixFromXYZ * self.xyz
        return gammaEncode_sRGB((displayP3Matrix[0, 0], displayP3Matrix[1, 0], displayP3Matrix[2, 0]))
    }
    
    var swiftUI: Color {
        let (r, g, b) = displayP3Components
        let colorSpace = CGColorSpace(name: CGColorSpace.displayP3)!
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
    
    var x: CGFloat {
        return xyz[0,0]
    }
    
    var y: CGFloat {
        return xyz[1,0]
    }
    
    var z: CGFloat {
        return xyz[2,0]
    }
    
    var chromaticity: (x: CGFloat, y: CGFloat) {
        let sum = x + y + z
        return (x / sum, y / sum)
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
    
    static var d50 = OklchColor(name: "D50", x: 0.964, y: 1, z: 0.825)
    static var d65 = OklchColor(name: "D65", x: 0.950, y: 1, z: 1.089)
    
}
