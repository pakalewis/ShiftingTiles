//
//  ColorPalette.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/13/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit

class ColorPalette {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    // The five combos are: 
    // Greens
    // Yellow/Blue
    // Blues
    // Gryffindor
    // Pink/Purple

    let lightColors = [
        UIColor(hex: 0x2f9000, alpha: 1),
        UIColor(hex: 0xf9ec48, alpha: 1),
        UIColor(hex: 0x73b9e6, alpha: 1),
        UIColor(hex: 0xd3a625, alpha: 1),
        UIColor(hex: 0xc79dd7, alpha: 1)
    ]
    
    let darkColors = [
        UIColor(hex: 0x083500, alpha: 1),
        UIColor(hex: 0x0c1d9a, alpha: 1),
        UIColor(hex: 0x2e4174, alpha: 1),
        UIColor(hex: 0x740001, alpha: 1),
        UIColor(hex: 0x673888, alpha: 1)
    ]


    
    func fetchLightColor() -> UIColor {
        let index = userDefaults.integerForKey("colorPaletteInt")
        if index >= 0 && index < 5 {
            return self.lightColors[index]
        }
        return self.lightColors[0]
    }


    func fetchDarkColor() -> UIColor {
        let index = userDefaults.integerForKey("colorPaletteInt")
        if index >= 0 && index < 5 {
            return self.darkColors[index]
        }
        return self.darkColors[0]
    }
}