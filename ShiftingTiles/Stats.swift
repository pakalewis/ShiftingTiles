//
//  Stats.swift
//  ShiftingTiles
//
//  Created by Parker Lewis on 1/6/15.
//  Copyright (c) 2015 Parker Lewis. All rights reserved.
//

import Foundation

class Stats {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let solvesAtSizeKeys = [
        "solvesAtSize2",
        "solvesAtSize3",
        "solvesAtSize4",
        "solvesAtSize5",
        "solvesAtSize6",
        "solvesAtSize7",
        "solvesAtSize8",
        "solvesAtSize9",
        "solvesAtSize10"
    ]
    var solvesAtSizeInts = [Int]()
    
    init () {
        self.solvesAtSizeInts = self.fetchSolvesPerSize()
    }

    
    func updateSolveStats(tilePerRow: Int) {
        
        // Update total solves
        var totalSolves = userDefaults.integerForKey("totalSolves")
        totalSolves++
        self.userDefaults.setInteger(totalSolves, forKey: "totalSolves")
        
        // Update solves for the appropriate size
        let key = self.solvesAtSizeKeys[tilePerRow - 2]
        var solves = userDefaults.integerForKey(key)
        solves++
        self.userDefaults.setInteger(solves, forKey: key)

        self.userDefaults.synchronize()
    }
    
    
    func fetchSolvesPerSize() -> [Int] {
        var solvesPerSizeArray = [Int]()
        for key in self.solvesAtSizeKeys {
            let integerForKey = self.userDefaults.integerForKey(key)
            solvesPerSizeArray.append(integerForKey)
        }
        return solvesPerSizeArray
    }
    
    
    func fetchTotalSolves() -> Int {
        return userDefaults.integerForKey("totalSolves")
    }
}



