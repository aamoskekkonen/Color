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
