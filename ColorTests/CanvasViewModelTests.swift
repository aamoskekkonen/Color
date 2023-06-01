//
//  CanvasViewModelTests.swift
//  ColorTests
//
//  Created by Aamos Kekkonen on 26.5.2023.
//

import XCTest
@testable import Color

final class CanvasViewModelTests: XCTestCase {
    var vm: CanvasViewModel!

    override func setUpWithError() throws {
        let colors = [OklchColor(name: "sRGB Red", x: 0.6400, y: 0.3300, z: 0.2126)]
        vm = CanvasViewModel(colors: colors, initialCanvasWidth: 350.0, initialPointDiameter: 15.0)
    }
    override func tearDownWithError() throws {
        vm = nil
    }
    
    func testInit() throws {
        let colorRepresentation = vm.data.first!
        let x = colorRepresentation.point.x
        let y = colorRepresentation.point.y
    }

}
