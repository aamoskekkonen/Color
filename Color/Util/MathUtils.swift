//
//  MathUtils.swift
//  Color
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import Foundation

func cubeRoot(_ value: CGFloat) -> CGFloat {
    return value >= 0 ? pow(value, 1.0/3) : -pow(-value, 1.0/3)
}

func gammaCorrect(_ value: CGFloat) -> CGFloat {
    if value <= 0.0031308 {
        return 12.92 * value
    } else {
        return 1.055 * pow(value, 1/2.2) - 0.055
    }
}

func gammaCorrect(_ values: (CGFloat, CGFloat, CGFloat)) -> (CGFloat, CGFloat, CGFloat) {
    return (gammaCorrect(values.0), gammaCorrect(values.1), gammaCorrect(values.2))
}

func convertToBase36(_ number: Int) -> Character {
    let base36Letters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let index = number % base36Letters.count
    let character = base36Letters[base36Letters.index(base36Letters.startIndex, offsetBy: index)]
    return character
}
