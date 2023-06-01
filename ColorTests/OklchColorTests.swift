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

    override func setUpWithError() throws {
        white = OklchColor(name: "White", x: 0.950, y: 1.000, z: 1.089)
        darkBrownish = OklchColor(name: "Dark Brownish", x: 1.000, y: 0.000, z: 0.000)
        babyGreenish = OklchColor(name: "Baby Greenish", x: 0.000, y: 1.000, z: 0.000)
        pitchBlackCyan = OklchColor(name: "Pitch Black Cyan", x: 0.000, y: 0.000, z: 1.000)
        d65 = OklchColor(name: "D65", xChromaticity: 0.3127, yChromaticity: 0.3290, luminance: 1.0000)
        sRGBRed = OklchColor(name: "sRGB Red", x: 0.6400, y: 0.3300, z: 0.2126)
        super.setUp()
    }

    override func tearDownWithError() throws {
        white = nil
        darkBrownish = nil
        babyGreenish = nil
        pitchBlackCyan = nil
        d65 = nil
        sRGBRed = nil
        super.tearDown()
    }
    

    func testInit() throws {
        XCTAssertEqual(white.l, 1.000, accuracy: 1e-4)
        XCTAssertEqual(white.c, 0.000, accuracy: 1e-3)
        XCTAssertEqual(white.h, 0.000, accuracy: 3e+2)
        
        XCTAssertEqual(darkBrownish.l, 0.450, accuracy: 1e-4)
        XCTAssertEqual(darkBrownish.c, 1.24, accuracy: 1e-2)
        XCTAssertEqual(darkBrownish.h, 359.12, accuracy: 1e-2)
        
        XCTAssertEqual(babyGreenish.l, 0.922, accuracy: 1e-3)
        XCTAssertEqual(babyGreenish.c, 0.72, accuracy: 1e-2)
        XCTAssertEqual(babyGreenish.h, 158.57, accuracy: 1e-1)
        
        XCTAssertEqual(pitchBlackCyan.l, 0.153, accuracy: 1e-3)
        XCTAssertEqual(pitchBlackCyan.c, 1.489, accuracy: 1e-2)
        XCTAssertEqual(pitchBlackCyan.h, 197.55, accuracy: 1e-1)
        
        XCTAssertEqual(d65.l, 1.000, accuracy: 1e-3)
        XCTAssertEqual(d65.c, 0.000, accuracy: 1e-3)
        XCTAssertEqual(d65.h, 0.000, accuracy: 3e+2)
    }

    func testDisplayP3() throws {
        
    }
    
}
