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
    
    var colorSchemeInt = 1
    
    
    var lightColor1 = UIColor(hex: 0xE8CF76, alpha: 1)
    var darkColor1 = UIColor(hex: 0x383F70, alpha: 1)
    var lightColor2 = UIColor(hex: 0x84A174, alpha: 1)
    var darkColor2 = UIColor(hex: 0x1A3C3D, alpha: 1)
    var lightColor3 = UIColor(hex: 0x73b9e6, alpha: 1)
    var darkColor3 = UIColor(hex: 0x2e4174, alpha: 1)
    var lightColor4 = UIColor(hex: 0x84bd68, alpha: 1)
    var darkColor4 = UIColor(hex: 0x857bb1, alpha: 1)
    
//    init() {
//        
//    }
    
    func fetchLightColor() -> UIColor {
        self.colorSchemeInt = userDefaults.integerForKey("colorPaletteInt")
        switch colorSchemeInt {
        case 1:
            return lightColor1
        case 2:
            return lightColor2
        case 3:
            return lightColor3
        case 4:
            return lightColor4
        default:
            return lightColor1
        }
    }


    func fetchDarkColor() -> UIColor {
        self.colorSchemeInt = userDefaults.integerForKey("colorPaletteInt")
        switch colorSchemeInt {
        case 1:
            return darkColor1
        case 2:
            return darkColor2
        case 3:
            return darkColor3
        case 4:
            return darkColor4
        default:
            return darkColor1
        }
    }

}