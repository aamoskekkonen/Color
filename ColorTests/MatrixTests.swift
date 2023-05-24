//
//  MatrixTests.swift
//  ColorTests
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import XCTest
@testable import Color

final class MatrixTests: XCTestCase {
    var matrix1: Matrix!
    var matrix2: Matrix!

    override func setUpWithError() throws {
        super.setUp()
        matrix1 = Matrix([[4.0, 7.0, 2.0], [3.0, 8.0, 6.0], [5.0, 1.0, 9.0]])
        matrix2 = Matrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0]])
    }

    override func tearDownWithError() throws {
        matrix1 = nil
        matrix2 = nil
        super.tearDown()
    }

    func testAddition() throws {
        let result = matrix1 + matrix2
        XCTAssertEqual(result.data, [[5.0, 9.0, 5.0], [7.0, 13.0, 12.0], [12.0, 9.0, 18.0]])
    }
    
    func testMultiplication() throws {
        let result = matrix1 * matrix2
        XCTAssertEqual(result.data, [[46.0, 59.0, 72.0], [77.0, 94.0, 111.0], [72.0, 87.0, 102.0]])
    }

    func testInverse() throws {
        let result = matrix1.inverse()
        XCTAssertTrue(result ≈ Matrix([[66.0/211, -61.0/211, 26.0/211], [3.0/211, 26.0/211, -18.0/211], [-37.0/211, 31.0/211, 11.0/211]]))
    }
    
    func testTranspose() throws {
        let result = matrix1.transpose()
        XCTAssertEqual(result.data, [[4.0, 3.0, 5.0], [7.0, 8.0, 1.0], [2.0, 6.0, 9.0]])
    }
    
}
