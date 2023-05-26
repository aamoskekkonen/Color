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
       let colors = [OklchColor(name: "Lilac", l: 0.75856, c: 0.06814, h: 326.22357)]
        vm = CanvasViewModel(colors: colors, initialCanvasWidth: 350.0, initialPointDiameter: 15.0)
    }
    override func tearDownWithError() throws {
        vm = nil
    }
    
    func testInit() throws {
        let lilacRepresentation = vm.data.first!
        let lilacX = lilacRepresentation.point.x
        let lilacY = lilacRepresentation.point.y
        /// complete later
    }

}
