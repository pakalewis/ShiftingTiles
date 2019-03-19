//
//  CongratsMessaging.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 3/8/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import Foundation

class Congrats {
    class func generateMessage() -> String {
        guard UserSettings.boolValue(for: .rotations) else { return "" }

        let randomInt = Int.random(in: 1...17)
        var key = "Message"
        if randomInt < 10 {
            key += "0"
        }
        key += String(randomInt)
        return NSLocalizedString(key, comment: "")
    }
}
