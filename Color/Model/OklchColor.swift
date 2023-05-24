//
//  OklchColor.swift
//  Color
//
//  Created by Aamos Kekkonen on 24.5.2023.
//

import Foundation

struct OklchColor {
    let l: CGFloat
    let c: CGFloat
    let h: CGFloat
    
    init(l: CGFloat, c: CGFloat, h: CGFloat) {
        self.l = l
        self.c = c
        self.h = h
    }
    
}
