//
//  Colors.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/13/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    // The five combos are:
    // Greens
    // Yellow/Blue
    // Blues
    // Gryffindor
    // Pink/Purple

    static let LightGreen = UIColor(hex: 0x2f9000, alpha: 1)
    static let LightYelllow = UIColor(hex: 0xf9ec48, alpha: 1)
    static let LightBlue = UIColor(hex: 0x73b9e6, alpha: 1)
    static let LightOrange = UIColor(hex: 0xd3a625, alpha: 1)
    static let LightPink = UIColor(hex: 0xc79dd7, alpha: 1)

    class func lights() -> [UIColor] {
        return [
            Colors.LightGreen,
            Colors.LightYelllow,
            Colors.LightBlue,
            Colors.LightOrange,
            Colors.LightPink
        ]
    }

    static let DarkGreen = UIColor(hex: 0x083500, alpha: 1)
    static let DarkNavy = UIColor(hex: 0x0c1d9a, alpha: 1)
    static let DarkBlue = UIColor(hex: 0x2e4174, alpha: 1)
    static let DarkRed = UIColor(hex: 0x740001, alpha: 1)
    static let DarkPurple = UIColor(hex: 0x673888, alpha: 1)

    class func darks() -> [UIColor] {
        return [
            Colors.DarkGreen,
            Colors.DarkNavy,
            Colors.DarkBlue,
            Colors.DarkRed,
            Colors.DarkPurple
        ]
    }


    class func fetchLightColor() -> UIColor {
        let index = UserSettings.intValue(for: .colorScheme)
        if index >= 0 && index < 5 {
            return Colors.lights()[index]
        }
        return Colors.lights()[0]
    }

    class func fetchDarkColor() -> UIColor {
        let index = UserSettings.intValue(for: .colorScheme)
        if index >= 0 && index < 5 {
            return Colors.darks()[index]
        }
        return Colors.darks()[0]
    }
}
