//
//  UserSettings.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 3/10/19.
//  Copyright © 2019 Parker Lewis. All rights reserved.
//

import UIKit

enum UserSettingsBoolKey: String {
    case
    firstLaunch,
    rotations,
    congratsMessages
}

enum UserSettingsIntKey: String {
    case
    tilePerRow,
    colorScheme,
    totalSolves,
    solvesAtSize2,
    solvesAtSize3,
    solvesAtSize4,
    solvesAtSize5,
    solvesAtSize6,
    solvesAtSize7,
    solvesAtSize8,
    solvesAtSize9,
    solvesAtSize10
}

class UserSettings {

    // BOOL
    class func toggle(key: UserSettingsBoolKey) {
        let existingValue = UserDefaults.standard.bool(forKey: key.rawValue)
        if existingValue {
            UserDefaults.standard.set(false, forKey: key.rawValue)
        } else {
            UserDefaults.standard.set(true, forKey: key.rawValue)
        }
    }

    class func set(bool: Bool, for key: UserSettingsBoolKey) {
        UserDefaults.standard.set(bool, forKey: key.rawValue)
    }

    class func boolValue(for key: UserSettingsBoolKey) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }



    // INT
    class func set(value: Int, for key: UserSettingsIntKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    class func intValue(for key: UserSettingsIntKey) -> Int {
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
}
