//
//  Stats.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/6/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import Foundation

class Stats {

    let solvesAtSizeKeys: [UserSettingsIntKey] = [
        .solvesAtSize2,
        .solvesAtSize3,
        .solvesAtSize4,
        .solvesAtSize5,
        .solvesAtSize6,
        .solvesAtSize7,
        .solvesAtSize8,
        .solvesAtSize9,
        .solvesAtSize10
    ]
    var solvesAtSizeInts = [Int]()
    
    init () {
        self.solvesAtSizeInts = self.fetchSolvesPerSize()
    }

    
    func updateSolveStats(_ tilePerRow: Int) {
        
        // Update total solves
        var totalSolves = fetchTotalSolves()
        totalSolves += 1
        UserSettings.set(value: totalSolves, for: .totalSolves)

        // Update solves for the appropriate size
        let key = self.solvesAtSizeKeys[tilePerRow - 2]
        var solves = UserSettings.intValue(for: key)
        solves += 1
        UserSettings.set(value: solves, for: key)
    }
    
    
    func fetchSolvesPerSize() -> [Int] {
        var solvesPerSizeArray = [Int]()
        for key in self.solvesAtSizeKeys {
            solvesPerSizeArray.append(UserSettings.intValue(for: key))
        }
        return solvesPerSizeArray
    }
    
    
    func fetchTotalSolves() -> Int {
        return UserSettings.intValue(for: .totalSolves)
    }
}



