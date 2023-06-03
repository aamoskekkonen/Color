//
//  OklchColorTests.swift
//  ColorTests
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import XCTest
@testable import Color

final class OklchColorTests: XCTestCase {
    var white: OklchColor!
    var darkBrownish: OklchColor!
    var babyGreenish: OklchColor!
    var pitchBlackCyan: OklchColor!
    var d65: OklchColor!
    var sRGBRed: OklchColor!
    var displayP3Red: OklchColor!
    var displayP3Green: OklchColor!
    var displayP3Blue: OklchColor!
    var midEverything: OklchColor!
    var aam: OklchColor!

    override func setUpWithError() throws {
        white = OklchColor(name: "White", x: 0.950, y: 1.000, z: 1.089)
        darkBrownish = OklchColor(name: "Dark Brownish", x: 1.000, y: 0.000, z: 0.000)
        babyGreenish = OklchColor(name: "Baby Greenish", x: 0.000, y: 1.000, z: 0.000)
        pitchBlackCyan = OklchColor(name: "Pitch Black Cyan", x: 0.000, y: 0.000, z: 1.000)
        d65 = OklchColor(name: "D65", xChromaticity: 0.3127, yChromaticity: 0.3290, luminance: 1.0000)
        sRGBRed = OklchColor(name: "sRGB Red", x: 0.6400, y: 0.3300, z: 0.2126)
        
        displayP3Red = OklchColor(name: "P3 Red", x: 0.680, y: 0.320, z: 0.265)
        displayP3Green = OklchColor(name: "P3 Green", x: 0.265, y: 0.690, z: 0.150)
        displayP3Blue = OklchColor(name: "P3 Blue", x: 0.150, y: 0.060, z: 0.790)
        
        midEverything = OklchColor(id: "55I")
        aam = OklchColor(id: "AAM")
        
        super.setUp()
    }

    override func tearDownWithError() throws {
        white = nil
        darkBrownish = nil
        babyGreenish = nil
        pitchBlackCyan = nil
        d65 = nil
        sRGBRed = nil
        displayP3Red = nil
        displayP3Green = nil
        displayP3Blue = nil
        midEverything = nil
        aam = nil
        super.tearDown()
    }
    

    func testInit() throws {
        XCTAssertEqual(white.l, 100.0, accuracy: 1e-2)
        XCTAssertEqual(white.c, 0.000, accuracy: 1e-3)
        XCTAssertEqual(white.h, 0.000, accuracy: 3e+2)
        
        XCTAssertEqual(darkBrownish.l, 45.0, accuracy: 1e-2)
        XCTAssertEqual(darkBrownish.c, 1.24, accuracy: 1e-2)
        XCTAssertEqual(darkBrownish.h, 359.12, accuracy: 1e-2)
        
        XCTAssertEqual(babyGreenish.l, 92.2, accuracy: 1e-1)
        XCTAssertEqual(babyGreenish.c, 0.72, accuracy: 1e-2)
        XCTAssertEqual(babyGreenish.h, 158.57, accuracy: 1e-1)
        
        XCTAssertEqual(pitchBlackCyan.l, 15.3, accuracy: 1e-1)
        XCTAssertEqual(pitchBlackCyan.c, 1.489, accuracy: 1e-2)
        XCTAssertEqual(pitchBlackCyan.h, 197.55, accuracy: 1e-1)
        
        XCTAssertEqual(d65.l, 100.0, accuracy: 1e-2)
        XCTAssertEqual(d65.c, 0.000, accuracy: 1e-3)
        XCTAssertEqual(d65.h, 0.000, accuracy: 3e+2)
        
        XCTAssertEqual(midEverything.l, 50.0)
        XCTAssertEqual(midEverything.c, 0.5)
        XCTAssertEqual(midEverything.h, 180)
        
        XCTAssertEqual(aam.l, 100.0)
        XCTAssertEqual(aam.c, 1.0)
        XCTAssertEqual(aam.h, 220)
    }

    func testDisplayP3() throws {
        let d65_red = d65.representative.sRGBComponents.red
        let d65_green = d65.representative.sRGBComponents.green
        let d65_blue = d65.representative.sRGBComponents.blue
        XCTAssertEqual(d65_red, 1.0, accuracy: 1e-5)
        XCTAssertEqual(d65_green, 1.0, accuracy: 1e-5)
        XCTAssertEqual(d65_blue, 1.0, accuracy: 1e-5)
        
        let sRGBRed_red =   sRGBRed.representative.sRGBComponents.red
        let sRGBRed_green = sRGBRed.representative.sRGBComponents.green
        let sRGBRed_blue =  sRGBRed.representative.sRGBComponents.blue
        XCTAssertEqual(sRGBRed_red, 0.4886, accuracy: 1e-5)
        XCTAssertEqual(sRGBRed_green, 0.2200, accuracy: 1e-5)
        XCTAssertEqual(sRGBRed_blue, 0.1789, accuracy: 1e-5)
        
        let displayP3Red_red = displayP3Red.representative.sRGBComponents.red
        let displayP3Red_green = displayP3Red.representative.sRGBComponents.green
        let displayP3Red_blue = displayP3Red.representative.sRGBComponents.blue
        XCTAssertEqual(displayP3Red_red, 1.0, accuracy: 1e-5)
        XCTAssertEqual(displayP3Red_green, 0.0, accuracy: 1e-5)
        XCTAssertEqual(displayP3Red_blue, 0.0, accuracy: 1e-5)
        
        let displayP3Green_red = displayP3Green.representative.sRGBComponents.red
        let displayP3Green_green = displayP3Green.representative.sRGBComponents.green
        let displayP3Green_blue = displayP3Green.representative.sRGBComponents.blue
        XCTAssertEqual(displayP3Green_red, 0.0, accuracy: 1e-5)
        XCTAssertEqual(displayP3Green_green, 1.0, accuracy: 1e-5)
        XCTAssertEqual(displayP3Green_blue, 0.0, accuracy: 1e-5)
        
        let displayP3Blue_red = displayP3Blue.representative.sRGBComponents.red
        let displayP3Blue_green = displayP3Blue.representative.sRGBComponents.green
        let displayP3Blue_blue = displayP3Blue.representative.sRGBComponents.blue
        XCTAssertEqual(displayP3Blue_red, 0.0, accuracy: 1e-5)
        XCTAssertEqual(displayP3Blue_green, 0.0, accuracy: 1e-5)
        XCTAssertEqual(displayP3Blue_blue, 1.0, accuracy: 1e-5)
    }
    
}
