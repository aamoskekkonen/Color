//
//  OklchColorTests.swift
//  ColorTests
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import XCTest
@testable import Color

final class OklchColorTests: XCTestCase {
    var d65_1: OklchColor!
    var darkBrownish: OklchColor!
    var babyGreenish: OklchColor!
    var pitchBlackCyan: OklchColor!
    var d65_2: OklchColor!
    var sRGBRed: OklchColor!
    var sRGBGreen: OklchColor!
    var sRGBBlue: OklchColor!
    var P3Red: OklchColor!
    var P3Green: OklchColor!
    var P3Blue: OklchColor!
    var midEverything: OklchColor!
    var aam: OklchColor!

    override func setUpWithError() throws {
        d65_1 = OklchColor(name: "White", x: 0.950, y: 1.000, z: 1.089)
        darkBrownish = OklchColor(name: "Dark Brownish", x: 1.000, y: 0.000, z: 0.000)
        babyGreenish = OklchColor(name: "Baby Greenish", x: 0.000, y: 1.000, z: 0.000)
        pitchBlackCyan = OklchColor(name: "Pitch Black Cyan", x: 0.000, y: 0.000, z: 1.000)
        
        d65_2 = OklchColor(name: "D65", xChromaticity: 0.3127, yChromaticity: 0.3290, luminance: 1)
        
        sRGBRed = OklchColor(name: "sRGB Red", xChromaticity: 0.6400, yChromaticity: 0.3300, luminance: 0.2126)
        sRGBGreen = OklchColor(name: "sRGB Green", xChromaticity: 0.3, yChromaticity: 0.6, luminance: 0.7152)
        sRGBBlue = OklchColor(name: "sRGB Blue", xChromaticity: 0.15, yChromaticity: 0.06, luminance: 0.0722)
        
        P3Red = OklchColor(name: "P3 Red", x: 0.4939, y: 0.2393, z: 0)
        P3Green = OklchColor(name: "P3 Green", x: 0.2524, y: 0.6938, z: 0.0553)
        P3Blue = OklchColor(name: "P3 Blue", x: 0.2042, y: 0.0669, z: 1.0352)
        
        midEverything = OklchColor(id: "55I")
        aam = OklchColor(id: "AAM")
        
        super.setUp()
    }

    override func tearDownWithError() throws {
        d65_1 = nil
        darkBrownish = nil
        babyGreenish = nil
        pitchBlackCyan = nil
        d65_2 = nil
        sRGBRed = nil
        sRGBGreen = nil
        sRGBBlue = nil
        P3Red = nil
        P3Green = nil
        P3Blue = nil
        midEverything = nil
        aam = nil
        super.tearDown()
    }
    

    func testInit() throws {
        XCTAssertEqual(d65_1.l, 100.0, accuracy: 1e-2)
        XCTAssertEqual(d65_1.c, 0.000, accuracy: 1e-3)
        XCTAssertEqual(d65_1.h, 0.000, accuracy: 3e+2)
        
        XCTAssertEqual(darkBrownish.l, 45.0, accuracy: 1e-2)
        XCTAssertEqual(darkBrownish.c, 1.24, accuracy: 1e-2)
        XCTAssertEqual(darkBrownish.h, 359.12, accuracy: 1e-2)
        
        XCTAssertEqual(babyGreenish.l, 92.2, accuracy: 1e-1)
        XCTAssertEqual(babyGreenish.c, 0.72, accuracy: 1e-2)
        XCTAssertEqual(babyGreenish.h, 158.57, accuracy: 1e-1)
        
        XCTAssertEqual(pitchBlackCyan.l, 15.3, accuracy: 1e-1)
        XCTAssertEqual(pitchBlackCyan.c, 1.489, accuracy: 1e-2)
        XCTAssertEqual(pitchBlackCyan.h, 197.55, accuracy: 1e-1)
        
        XCTAssertEqual(d65_2.l, 100.0, accuracy: 1e-2)
        XCTAssertEqual(d65_2.c, 0.000, accuracy: 1e-3)
        XCTAssertEqual(d65_2.h, 0.000, accuracy: 3e+2)
        
        XCTAssertEqual(midEverything.l, 50.0)
        XCTAssertEqual(midEverything.c, 0.5)
        XCTAssertEqual(midEverything.h, 180)
        
        XCTAssertEqual(aam.l, 100.0)
        XCTAssertEqual(aam.c, 1.0)
        XCTAssertEqual(aam.h, 220)
    }
    
    func testSRGB() throws {
        let d65_r = d65_2.sRGBComponents.red
        let d65_g = d65_2.sRGBComponents.green
        let d65_b = d65_2.sRGBComponents.blue
        XCTAssertEqual(d65_r, 1, accuracy: 1e-4)
        XCTAssertEqual(d65_g, 1, accuracy: 1e-4)
        XCTAssertEqual(d65_b, 1, accuracy: 1e-4)
        
        let sRGBRed_r = sRGBRed.sRGBComponents.red
        let sRGBRed_g = sRGBRed.sRGBComponents.green
        let sRGBRed_b = sRGBRed.sRGBComponents.blue
        XCTAssertEqual(sRGBRed_r, 1, accuracy: 1e-3)
        XCTAssertEqual(sRGBRed_g, 0, accuracy: 1e-2)
        XCTAssertEqual(sRGBRed_b, 0, accuracy: 1e-3)
        
        let sRGBGreen_r = sRGBGreen.sRGBComponents.red
        let sRGBGreen_g = sRGBGreen.sRGBComponents.green
        let sRGBGreen_b = sRGBGreen.sRGBComponents.blue
        XCTAssertEqual(sRGBGreen_r, 0, accuracy: 1e-4)
        XCTAssertEqual(sRGBGreen_g, 1, accuracy: 1e-3)
        XCTAssertEqual(sRGBGreen_b, 0, accuracy: 1e-3)
        
        let sRGBBlue_r = sRGBBlue.sRGBComponents.red
        let sRGBBlue_g = sRGBBlue.sRGBComponents.green
        let sRGBBlue_b = sRGBBlue.sRGBComponents.blue
        XCTAssertEqual(sRGBBlue_r, 0, accuracy: 1e-3)
        XCTAssertEqual(sRGBBlue_g, 0, accuracy: 1e-4)
        XCTAssertEqual(sRGBBlue_b, 1, accuracy: 1e-4)
    }

    func testDisplayP3() throws {
        let P3Red_r = P3Red.displayP3Components.red
        let P3Red_g = P3Red.displayP3Components.green
        let P3Red_b = P3Red.displayP3Components.blue
        XCTAssertEqual(P3Red_r, 1, accuracy: 1e-5)
        XCTAssertEqual(P3Red_g, 0, accuracy: 1e-5)
        XCTAssertEqual(P3Red_b, 0, accuracy: 1e-5)
        
        let P3Green_r = P3Green.displayP3Components.red
        let P3Green_g = P3Green.displayP3Components.green
        let P3Green_b = P3Green.displayP3Components.blue
        XCTAssertEqual(P3Green_r, 0, accuracy: 1e-5)
        XCTAssertEqual(P3Green_g, 1, accuracy: 1e-5)
        XCTAssertEqual(P3Green_b, 0, accuracy: 1e-5)
        
        let P3Blue_r = P3Blue.displayP3Components.red
        let P3Blue_g = P3Blue.displayP3Components.green
        let P3Blue_b = P3Blue.displayP3Components.blue
        XCTAssertEqual(P3Blue_r, 0, accuracy: 1e-5)
        XCTAssertEqual(P3Blue_g, 0, accuracy: 1e-5)
        XCTAssertEqual(P3Blue_b, 1, accuracy: 1e-5)
    }
    
}
