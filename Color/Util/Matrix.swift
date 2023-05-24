//
//  Matrix.swift
//  Color
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import Foundation

infix operator ≈: ComparisonPrecedence

struct Matrix {
    var data: [[Double]]

    init(_ data: [[Double]]) {
        self.data = data
    }

    var rows: Int {
        return data.count
    }

    var columns: Int {
        return data[0].count
    }

    subscript(row: Int, col: Int) -> Double {
        get {
            assert(row < rows && col < columns, "Index out of range")
            return data[row][col]
        }
        set {
            assert(row < rows && col < columns, "Index out of range")
            data[row][col] = newValue
        }
    }
}

func + (left: Matrix, right: Matrix) -> Matrix {
    assert(left.rows == right.rows && left.columns == right.columns, "Matrix dimensions should match for addition.")
    var result = Matrix(left.data)
    for i in 0..<left.rows {
        for j in 0..<left.columns {
            result[i, j] += right[i, j]
        }
    }
    return result
}

func * (left: Matrix, right: Matrix) -> Matrix {
    assert(left.columns == right.rows, "Matrix dimensions should match for multiplication.")
    var result: Matrix = Matrix(Array(repeating: Array(repeating: 0.0, count: right.columns), count: left.rows))
    for i in 0..<left.rows {
        for j in 0..<right.columns {
            for k in 0..<left.columns {
                result[i, j] += left[i, k] * right[k, j]
            }
            
        }
    }
    return result
}

func ≈ (left: Matrix, right: Matrix) -> Bool {
    let tolerance: Double = 1e-6
    assert(left.rows == right.rows && left.columns == right.columns, "Matrix dimensions should match for comparison.")
    for i in 0..<left.rows {
        for j in 0..<left.columns {
            if abs(left[i, j] - right[i, j]) > tolerance {
                return false
            }
        }
    }
    return true
}

extension Matrix {
    func inverse() -> Matrix {
        assert(rows == columns, "Matrix must be square for inversion.")
        
        let n = rows
        var id = Matrix(Array(repeating: Array(repeating: 0.0, count: n), count: n))
        for i in 0..<n {
            id[i, i] = 1
        }

        var matrix = self

        for i in 0..<n {
            var maxRow = i
            for j in i+1..<n {
                if abs(matrix[j, i]) > abs(matrix[maxRow, i]) {
                    maxRow = j
                }
            }

            matrix.data.swapAt(i, maxRow)
            id.data.swapAt(i, maxRow)

            let ii = matrix[i, i]

            for j in 0..<n {
                matrix[i, j] /= ii
                id[i, j] /= ii
            }

            for j in 0..<n {
                if i != j {
                    let d = matrix[j, i]
                    for k in 0..<n {
                        matrix[j, k] -= matrix[i, k] * d
                        id[j, k] -= id[i, k] * d
                    }
                }
            }
        }

        return id
    }
    
    func transpose() -> Matrix {
        var result: Matrix = Matrix(Array(repeating: Array(repeating: 0.0, count: self.rows), count: self.columns))
        for i in 0..<self.rows {
            for j in 0..<self.columns {
                result[j, i] = self[i, j]
            }
        }
        return result
    }
}
