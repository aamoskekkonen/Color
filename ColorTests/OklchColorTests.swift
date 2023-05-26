//
//  OklchColorTests.swift
//  ColorTests
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import XCTest
@testable import Color

final class OklchColorTests: XCTestCase {
    var color1: OklchColor!
    var color2: OklchColor!
    var color3: OklchColor!
    var color4: OklchColor!
    var color5: OklchColor!
    var color6: OklchColor!

    override func setUpWithError() throws {
        color1 = OklchColor(name: "White", x: 0.950, y: 1.000, z: 1.089)
        color2 = OklchColor(name: "Dark Brownish", x: 1.000, y: 0.000, z: 0.000)
        color3 = OklchColor(name: "Baby Greenish", x: 0.000, y: 1.000, z: 0.000)
        color4 = OklchColor(name: "Pitch Black Cyan", x: 0.000, y: 0.000, z: 1.000)
        color5 = OklchColor(name: "D65", xChromaticity: 0.3127, yChromaticity: 0.3290, luminance: 1.0000)
        color6 = OklchColor(name: "sRGB Red", x: 0.6400, y: 0.3300, z: 0.2126)
        super.setUp()
    }

    override func tearDownWithError() throws {
        color1 = nil
        color2 = nil
        color3 = nil
        color4 = nil
        color5 = nil
        color6 = nil
        super.tearDown()
    }
    

    func testInit() throws {
        XCTAssertEqual(color1.l, 1.000, accuracy: 1e-4)
        XCTAssertEqual(color1.c, 0.000, accuracy: 1e-3)
        XCTAssertEqual(color1.h, 0.000, accuracy: 3e+2)
        
        XCTAssertEqual(color2.l, 0.450, accuracy: 1e-4)
        XCTAssertEqual(color2.c, 1.24, accuracy: 1e-2)
        XCTAssertEqual(color2.h, 359.12, accuracy: 1e-2)
        
        XCTAssertEqual(color3.l, 0.922, accuracy: 1e-3)
        XCTAssertEqual(color3.c, 0.72, accuracy: 1e-2)
        XCTAssertEqual(color3.h, 158.57, accuracy: 1e-1)
        
        XCTAssertEqual(color4.l, 0.153, accuracy: 1e-3)
        XCTAssertEqual(color4.c, 1.489, accuracy: 1e-2)
        XCTAssertEqual(color4.h, 197.55, accuracy: 1e-1)
        
        XCTAssertEqual(color5.l, 1.000, accuracy: 1e-3)
        XCTAssertEqual(color5.c, 0.000, accuracy: 1e-3)
        XCTAssertEqual(color5.h, 0.000, accuracy: 3e+2)
    }


}
